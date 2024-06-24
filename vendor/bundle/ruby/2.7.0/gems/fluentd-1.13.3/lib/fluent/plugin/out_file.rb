#
# Fluentd
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#

require 'fileutils'
require 'zlib'
require 'time'

require 'fluent/plugin/output'
require 'fluent/config/error'
# TODO remove ...
require 'fluent/plugin/file_util'

module Fluent::Plugin
  class FileOutput < Output
    Fluent::Plugin.register_output('file', self)

    helpers :formatter, :inject, :compat_parameters

    SUPPORTED_COMPRESS = [:text, :gz, :gzip]
    SUPPORTED_COMPRESS_MAP = {
      text: nil,
      gz: :gzip,
      gzip: :gzip,
    }

    DEFAULT_TIMEKEY = 60 * 60 * 24

    desc "The Path of the file."
    config_param :path, :string

    desc "Specify to add file suffix for bare file path or not."
    config_param :add_path_suffix, :bool, default: true
    desc "The file suffix added to bare file path."
    config_param :path_suffix, :string, default: '.log'
    desc "The flushed chunk is appended to existence file or not."
    config_param :append, :bool, default: false
    desc "Compress flushed file."
    config_param :compress, :enum, list: SUPPORTED_COMPRESS, default: :text
    desc "Execute compression again even when buffer chunk is already compressed."
    config_param :recompress, :bool, default: false
    desc "Create symlink to temporary buffered file when buffer_type is file (disabled on Windows)."
    config_param :symlink_path, :string, default: nil

    config_section :format do
      config_set_default :@type, 'out_file'
    end

    config_section :buffer do
      config_set_default :@type, 'file'
      config_set_default :chunk_keys, ['time']
      config_set_default :timekey, DEFAULT_TIMEKEY
    end

    attr_reader :dir_perm
    attr_accessor :last_written_path # for tests

    module SymlinkBufferMixin
      def metadata(timekey: nil, tag: nil, variables: nil)
        metadata = super

        @latest_metadata ||= new_metadata(timekey: 0)
        if metadata.timekey && (metadata.timekey >= @latest_metadata.timekey)
          @latest_metadata = metadata
        end

        metadata
      end

      def output_plugin_for_symlink=(output_plugin)
        @_output_plugin_for_symlink = output_plugin
      end

      def symlink_path=(path)
        @_symlink_path = path
      end

      def generate_chunk(metadata)
        chunk = super
        # "symlink" feature is to link from symlink_path to the latest file chunk. Records with latest
        # timekey will be appended into that file chunk. On the other side, resumed file chunks might NOT
        # have timekey, especially in the cases that resumed file chunks are generated by Fluentd v0.12.
        # These chunks will be enqueued immediately, and will be flushed soon.
        if chunk.metadata == @latest_metadata
          sym_path = @_output_plugin_for_symlink.extract_placeholders(@_symlink_path, chunk)
          FileUtils.mkdir_p(File.dirname(sym_path), mode: @_output_plugin_for_symlink.dir_perm)
          FileUtils.ln_sf(chunk.path, sym_path)
        end
        chunk
      end
    end

    def configure(conf)
      compat_parameters_convert(conf, :formatter, :buffer, :inject, default_chunk_key: "time")

      configured_time_slice_format = conf['time_slice_format']

      if conf.elements(name: 'buffer').empty?
        conf.add_element('buffer', 'time')
      end
      buffer_conf = conf.elements(name: 'buffer').first
      # Fluent::PluginId#configure is not called yet, so we can't use #plugin_root_dir here.
      if !buffer_conf.has_key?('path') && !(conf['@id'] && system_config.root_dir)
        # v0.14 file buffer handles path as directory if '*' is missing
        # 'dummy_path' is not to raise configuration error for 'path' in file buffer plugin,
        # but raise it in this plugin.
        buffer_conf['path'] = conf['path'] || '/tmp/dummy_path'
      end

      if conf.has_key?('utc') || conf.has_key?('localtime')
        param_name = conf.has_key?('utc') ? 'utc' : 'localtime'
        log.warn "'#{param_name}' is deprecated for output plugin. This parameter is used for formatter plugin in compatibility layer. If you want to use same feature, use timekey_use_utc parameter in <buffer> directive instead"
      end

      super

      @compress_method = SUPPORTED_COMPRESS_MAP[@compress]

      if @path.include?('*') && !@buffer_config.timekey
        raise Fluent::ConfigError, "path including '*' must be used with buffer chunk key 'time'"
      end

      path_suffix = @add_path_suffix ? @path_suffix : ''
      path_timekey = if @chunk_key_time
                       @as_secondary ? @primary_instance.buffer_config.timekey : @buffer_config.timekey
                     else
                       nil
                     end
      @path_template = generate_path_template(@path, path_timekey, @append, @compress_method, path_suffix: path_suffix, time_slice_format: configured_time_slice_format)

      if @as_secondary
        # When this plugin is configured as secondary & primary plugin has tag key, but this plugin may not have it.
        # Increment placeholder can make another output file per chunk tag/keys even if original path doesn't include it.
        placeholder_validators(:path, @path_template).select{|v| v.type == :time }.each do |v|
          v.validate!
        end
      else
        placeholder_validate!(:path, @path_template)

        max_tag_index = get_placeholders_tag(@path_template).max || 1
        max_tag_index = 1 if max_tag_index < 1
        dummy_tag = (['a'] * max_tag_index).join('.')
        dummy_record_keys = get_placeholders_keys(@path_template) || ['message']
        dummy_record = Hash[dummy_record_keys.zip(['data'] * dummy_record_keys.size)]

        test_chunk1 = chunk_for_test(dummy_tag, Fluent::EventTime.now, dummy_record)
        test_path = extract_placeholders(@path_template, test_chunk1)
        unless ::Fluent::FileUtil.writable_p?(test_path)
          raise Fluent::ConfigError, "out_file: `#{test_path}` is not writable"
        end
      end

      @formatter = formatter_create

      if @symlink_path && @buffer.respond_to?(:path)
        if @as_secondary
          raise Fluent::ConfigError, "symlink_path option is unavailable in <secondary>: consider to use secondary_file plugin"
        end
        if Fluent.windows?
          log.warn "symlink_path is unavailable on Windows platform. disabled."
          @symlink_path = nil
        else
          @buffer.extend SymlinkBufferMixin
          @buffer.symlink_path = @symlink_path
          @buffer.output_plugin_for_symlink = self
        end
      end

      @dir_perm = system_config.dir_permission || Fluent::DEFAULT_DIR_PERMISSION
      @file_perm = system_config.file_permission || Fluent::DEFAULT_FILE_PERMISSION
      @need_lock = system_config.workers > 1
    end

    def multi_workers_ready?
      true
    end

    def format(tag, time, record)
      r = inject_values_to_record(tag, time, record)
      @formatter.format(tag, time, r)
    end

    def write(chunk)
      path = extract_placeholders(@path_template, chunk)
      FileUtils.mkdir_p File.dirname(path), mode: @dir_perm

      writer = case
               when @compress_method.nil?
                 method(:write_without_compression)
               when @compress_method == :gzip
                 if @buffer.compress != :gzip || @recompress
                   method(:write_gzip_with_compression)
                 else
                   method(:write_gzip_from_gzipped_chunk)
                 end
               else
                 raise "BUG: unknown compression method #{@compress_method}"
               end

      if @append
        writer.call(path, chunk)
      else
        find_filepath_available(path, with_lock: @need_lock) do |actual_path|
          writer.call(actual_path, chunk)
          path = actual_path
        end
      end

      @last_written_path = path
    end

    def write_without_compression(path, chunk)
      File.open(path, "ab", @file_perm) do |f|
        chunk.write_to(f)
      end
    end

    def write_gzip_with_compression(path, chunk)
      File.open(path, "ab", @file_perm) do |f|
        gz = Zlib::GzipWriter.new(f)
        chunk.write_to(gz, compressed: :text)
        gz.close
      end
    end

    def write_gzip_from_gzipped_chunk(path, chunk)
      File.open(path, "ab", @file_perm) do |f|
        chunk.write_to(f, compressed: :gzip)
      end
    end

    def timekey_to_timeformat(timekey)
      case timekey
      when nil          then ''
      when 0...60       then '%Y%m%d%H%M%S' # 60 exclusive
      when 60...3600    then '%Y%m%d%H%M'
      when 3600...86400 then '%Y%m%d%H'
      else                   '%Y%m%d'
      end
    end

    def compression_suffix(compress)
      case compress
      when :gzip then '.gz'
      when nil then ''
      else
        raise ArgumentError, "unknown compression type #{compress}"
      end
    end

    # /path/to/dir/file.*      -> /path/to/dir/file.%Y%m%d
    # /path/to/dir/file.*.data -> /path/to/dir/file.%Y%m%d.data
    # /path/to/dir/file        -> /path/to/dir/file.%Y%m%d.log
    #   %Y%m%d -> %Y%m%d_** (non append)
    # + .gz (gzipped)
    ## TODO: remove time_slice_format when end of support of compat_parameters
    def generate_path_template(original, timekey, append, compress, path_suffix: '', time_slice_format: nil)
      comp_suffix = compression_suffix(compress)
      index_placeholder = append ? '' : '_**'
      if original.index('*')
        raise "BUG: configuration error must be raised for path including '*' without timekey" unless timekey
        time_placeholders_part = time_slice_format || timekey_to_timeformat(timekey)
        original.gsub('*', time_placeholders_part + index_placeholder) + comp_suffix
      else
        if timekey
          if time_slice_format
            "#{original}.#{time_slice_format}#{index_placeholder}#{path_suffix}#{comp_suffix}"
          else
            time_placeholders = timekey_to_timeformat(timekey)
            if time_placeholders.scan(/../).any?{|ph| original.include?(ph) }
              raise Fluent::ConfigError, "insufficient timestamp placeholders in path" if time_placeholders.scan(/../).any?{|ph| !original.include?(ph) }
              "#{original}#{index_placeholder}#{path_suffix}#{comp_suffix}"
            else
              "#{original}.#{time_placeholders}#{index_placeholder}#{path_suffix}#{comp_suffix}"
            end
          end
        else
          "#{original}#{index_placeholder}#{path_suffix}#{comp_suffix}"
        end
      end
    end

    def find_filepath_available(path_with_placeholder, with_lock: false) # for non-append
      raise "BUG: index placeholder not found in path: #{path_with_placeholder}" unless path_with_placeholder.index('_**')
      i = 0
      dir_path = locked = nil
      while true
        path = path_with_placeholder.sub('_**', "_#{i}")
        i += 1
        next if File.exist?(path)

        if with_lock
          dir_path = path + '.lock'
          locked = Dir.mkdir(dir_path) rescue false
          next unless locked
          # ensure that other worker doesn't create a file (and release lock)
          # between previous File.exist? and Dir.mkdir
          next if File.exist?(path)
        end

        break
      end
      yield path
    ensure
      if dir_path && locked && Dir.exist?(dir_path)
        Dir.rmdir(dir_path) rescue nil
      end
    end
  end
end
