class Fluentd
  module Setting
    module PluginConfig
      extend ActiveSupport::Concern

      included do
        validate :validate_configuration
      end

      def validate_configuration
        original_log = $log
        $log = DummyLogger.logger
        full_config = to_config.to_s
        config = if full_config.start_with?("<label ")
                   full_config.lines[2..-3].join
                 else
                   full_config.lines[1..-2].join
                 end
        self.class.create_driver(config)
      rescue Fluent::ConfigError => ex
        errors.add(:base, :invalid, message: ex.message)
      ensure
        $log = original_log
      end

      def to_config
        name = case plugin_type
               when "input"
                 "source"
               when "output"
                 "match"
               when "filter"
                 "filter"
               when "parser"
                 "parse"
               when "formatter"
                 "format"
               when "buffer"
                 "buffer"
               when "storage"
                 "storage"
               end
        _attributes = attributes.reject do |key, value|
          %w(parse_type format_type buffer_type storage_type).include?(key.to_s)
        end
        _attributes = { "@type" => self.plugin_name }.merge(_attributes)
        _attributes["@log_level"] = _attributes.delete("log_level")
        label = _attributes.delete("label")
        if plugin_type == "input"
          _attributes["@label"] = label
        end
        argument = case plugin_type
                   when "output", "filter", "buffer"
                     _attributes.delete(self._argument_name.to_s) || ""
                   else
                     ""
                   end
        attrs, elements = parse_attributes(_attributes)
        case plugin_type
        when "output", "filter"
          # e is <match> or <filter>
          e = config_element(name, argument, attrs, elements)
          if label.blank?
            e
          else
            config_element("label", label, {}, [e])
          end
        else
          config_element(name, argument, attrs, elements)
        end
      end

      def parse_attributes(attributes)
        base_klasses = config_definition.keys
        sections, params = attributes.partition do |key, _section_attributes|
          base_klasses.any? do |base_klass|
            config_definition.dig(base_klass, key.to_sym, :section) || config_definition.dig(key.to_sym, :section)
          end
        end
        elements = []
        sections.to_h.each do |key, section_params|
          next if section_params.blank?
          section_class = self._sections[key.to_sym]
          if %w(parse format buffer storage).include?(key)
            if section_params && section_params.key?("0")
              section_params["0"] = { "type" => self.attributes["#{key}_type"] }.merge(section_params["0"])
            else
              section_params = {
                "0" => { "type" => self.attributes["#{key}_type"] }
              }
            end
          end
          _elements = section_params.map do |index, _section_params|
            section_class.new(_section_params).to_config
          end.compact
          elements.concat(_elements)
        end
        params = params.to_h
        if plugin_type == "filter" && plugin_name == "record_transformer"
          record_params = {}
          params.delete("record").lines.each do |line|
            k, v = line.split(" ", 2)
            record_params[k] = v
          end
          elements << config_element("record", "", record_params, [])
        end
        attrs = params.reject do |key, value|
          skip?(key.to_sym, value)
        end
        return attrs, elements
      end

      # copy from Fluent::Test::Helpers#config_element
      def config_element(name = 'test', argument = '', params = {}, elements = [])
        Fluent::Config::Element.new(name, argument, params, elements)
      end

      def skip?(key, value)
        return true if value.blank?
        if self._defaults.key?(key)
          self.class.reformat_value(key, self._defaults[key]) == self.class.reformat_value(key, value)
        else
          false
        end
      end
    end
  end
end
