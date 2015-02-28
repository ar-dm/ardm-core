require 'spec_helper'

describe DataMapper::Property::Discriminator do
  before :each do
    Object.send(:remove_const, :Foo) if defined?(Foo)
    Object.send(:remove_const, :Bar) if defined?(Bar)

    class ::Foo; end
    class ::Bar; end

    @name          = :type
    @type          = described_class
    @value         = Foo
    @other_value   = Bar
    @invalid_value = 1
  end

  include_examples 'A semipublic Property'
end
