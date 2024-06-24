module RR
  module DoubleDefinitions
    module DoubleInjections
      class AnyInstanceOf
        extend(Module.new do
          include RR::DSL

          def call(subject_class, stubbed_methods=nil, &block)
            strategy_lambda = lambda do |double_definition_create|
              ::RR::DoubleDefinitions::Strategies::DoubleInjection::AnyInstanceOf.new(double_definition_create)
            end
            ::RR::DoubleDefinitions::DoubleDefinitionCreate.set_default_double_injection_strategy(strategy_lambda) do
              if stubbed_methods
                subject_class.class_eval do
                  stubbed_methods.each do |name, value|
                    value_proc = value.is_a?(Proc) ? value : lambda {value}
                    RR.stub(subject_class, name).returns(&value_proc)
                  end
                end
              else
                block.call(subject_class)
              end
            end
          end
        end)
      end
    end
  end
end
