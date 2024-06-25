class Fluentd
  module Setting
    class ParserApacheError
      include Fluentd::Setting::Plugin

      register_plugin("parser", "apache_error")

      def self.initial_params
        {}
      end
    end
  end
end
