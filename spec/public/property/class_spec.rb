require 'spec_helper'

describe DataMapper::Property::Class do
  before :each do
    Object.send(:remove_const, :Foo) if defined?(Foo)
    Object.send(:remove_const, :Bar) if defined?(Bar)

    class ::Foo; end
    class ::Bar; end

    @name          = :type
    @type          = described_class
    @primitive     = Class
    @value         = Foo
    @other_value   = Bar
    @invalid_value = 1
  end

  include_examples 'A public Property'

  describe '.options' do
    subject { described_class.options }

    it { should be_kind_of(Hash) }

    it { should eql(:primitive => @primitive) }
  end
end
