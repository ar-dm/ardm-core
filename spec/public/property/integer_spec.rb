require 'spec_helper'

describe DataMapper::Property::Integer do
  before :each do
    @name          = :age
    @type          = described_class
    @primitive     = Integer
    @value         = 1
    @other_value   = 2
    @invalid_value = '1'
  end

  include_examples 'A public Property'

  describe '.options' do
    subject { described_class.options }

    it { should be_kind_of(Hash) }

    it { should eql(:primitive => @primitive) }
  end
end
