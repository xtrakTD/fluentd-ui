shared_context 'stub + instance_of + strong' do
  include StubDefinitionCreatorHelpers

  context 'where subject is a class', method_type: :class do
    context 'where methods being doubled already exist', methods_exist: true do
      include_context 'tests for a double definition creator method that supports stubbing'

      it_behaves_like 'comparing the arity between the method and double definition'

      it "lets you stub methods which are called in #initialize" do
        klass = Class.new do
          def initialize; method_run_in_initialize; end
          def method_run_in_initialize; end
        end
        method_double_called = false
        double_creator = double_definition_creator_for(klass)
        double_creator.method_run_in_initialize { method_double_called = true }
        klass.new
        expect(method_double_called).to eq true
      end
    end

    context 'where methods being doubled do not already exist', methods_exist: false do
      it "doesn't work" do
        klass = Class.new
        double_creator = double_definition_creator_for(klass)
        expect { double_creator.some_method }.to \
          raise_error(RR::Errors::SubjectDoesNotImplementMethodError)
      end
    end
  end

  context 'where subject is an instance of a class', method_type: :instance do
    it "doesn't work" do
      double_creator = double_definition_creator_for(Object.new)
      expect { double_creator.some_method }.to raise_error(ArgumentError)
    end
  end
end
