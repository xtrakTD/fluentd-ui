ActiveModel::Type.register(:array, Fluentd::Setting::Type::Array)
ActiveModel::Type.register(:enum, Fluentd::Setting::Type::Enum)
ActiveModel::Type.register(:bool, Fluentd::Setting::Type::Bool)
ActiveModel::Type.register(:hash, Fluentd::Setting::Type::Hash)
ActiveModel::Type.register(:object, Fluentd::Setting::Type::Object)
ActiveModel::Type.register(:regexp, Fluentd::Setting::Type::Regexp)
ActiveModel::Type.register(:size, Fluentd::Setting::Type::Size)
ActiveModel::Type.register(:section, Fluentd::Setting::Type::Section)
