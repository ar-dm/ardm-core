require 'spec_helper'

describe DataMapper::Property::String do
  before :each do
    @name          = :name
    @type          = described_class
    @primitive     = String
    @value         = 'value'
    @other_value   = 'return value'
    @invalid_value = 1
  end

  include_examples 'A public Property'

  describe '.options' do
    subject { described_class.options }

    it { should be_kind_of(Hash) }

    it { should eql(:primitive => @primitive, :length => 50) }
  end
end
