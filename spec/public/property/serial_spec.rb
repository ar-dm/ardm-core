require 'spec_helper'

describe DataMapper::Property::Serial do
  before :each do
    @name          = :id
    @type          = described_class
    @primitive     = Integer
    @value         = 1
    @other_value   = 2
    @invalid_value = 'foo'
  end

  include_examples 'A public Property'

  describe '.options' do
    subject { described_class.options }

    it { should be_kind_of(Hash) }

    it { should eql(:primitive => @primitive, :min => 1, :serial => true) }
  end
end
