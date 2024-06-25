class Fluentd
  module Setting
    module PluginParameter
      extend ActiveSupport::Concern

      include Fluentd::Setting::Configurable

      def column_type(name)
        self.class.column_type(name)
      end

      def list_of(name)
        self.class.list_of(name)
      end

      def desc(name)
        self.class.desc(name)
      end

      def default(name)
        self.class.reformat_value(name, self.class.default(name))
      end

      def common_options
        []
      end

      def advanced_options
        all_options - common_options - hidden_options
      end

      def hidden_options
        []
      end

      def all_options
        self.class._types.keys + self.class._sections.keys
      end

      def have_buffer_section?
        self.class.have_buffer_section?
      end

      def have_storage_section?
        self.class.have_storage_section?
      end

      def have_parse_section?
        self.class.have_parse_section?
      end

      def have_format_section?
        self.class.have_format_section?
      end

      def create_buffer
        return unless have_buffer_section?
        buffer_class = Fluentd::Setting.const_get("buffer_#{buffer_type}".classify)
        buffer_class.new(buffer["0"].except("type"))
      end

      def create_storage
        return unless have_storage_section?
        storage_class = Fluentd::Setting.const_get("storage_#{storage_type}".classify)
        storage_class.new(storage["0"].except("type"))
      end

      def create_parser
        return unless have_parse_section?
        parser_class = Fluentd::Setting.const_get("parser_#{parse_type}".classify)
        parser_class.new(parse["0"].except("type"))
      end

      def create_formatter
        return unless have_format_section?
        formatter_class = Fluentd::Setting.const_get("formatter_#{format_type}".classify)
        formatter_class.new(format["0"].except("type"))
      end

      module ClassMethods
        def column_type(name)
          self._types[name]
        end

        def list_of(name)
          self._list[name]
        end

        def desc(name)
          self._descriptions[name]
        end

        def default(name)
          reformat_value(name, self._defaults[name])
        end

        def have_buffer_section?
          self._sections.key?(:buffer)
        end

        def have_storage_section?
          self._sections.key?(:storage)
        end

        def have_parse_section?
          self._sections.key?(:parse)
        end

        def have_format_section?
          self._sections.key?(:format)
        end

        def initial_params
          new # ensure to load attributes
          params = {}
          self._defaults.each do |key, value|
            if key.to_s.start_with?("@")
              params[key.to_s[1..-1].to_sym] = value
            else
              params[key] = value
            end
          end
          self._sections.each do |key, section|
            next if section.initial_params.blank?
            params[key] = {
              "0" => section.initial_params.stringify_keys
            }
          end
          params
        end

        def permit_params
          self.new # init
          keys = self._types.keys
          self._sections.each do |key, section|
            keys << _permit_section(key, section)
          end

          keys << :buffer_type if have_buffer_section?
          keys << :storage_type if have_storage_section?
          keys << :parse_type if have_parse_section?
          keys << :format_type if have_format_section?

          keys
        end

        def _permit_section(key, section)
          keys = { key => section._types.keys }
          section._sections.each do |_key, _section|
            keys[key] << _permit_section(_key, _section)
          end
          keys
        end

        def reformat_value(name, value)
          type = column_type(name)
          return value if type.nil? # name == :time_key
          return value.to_sym if type == :enum
          return value if type == :regexp
          type_name = if type.is_a?(Fluentd::Setting::Type::Time)
                        :time
                      else
                        type
                      end
          begin
            Fluent::Config::REFORMAT_VALUE.call(type_name, value.dup)
          rescue TypeError
            Fluent::Config::REFORMAT_VALUE.call(type_name, value)
          end
        end
      end
    end
  end
end
