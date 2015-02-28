require 'spec_helper'

describe DataMapper::Property::Float do
  before :each do
    @name          = :rating
    @type          = described_class
    @primitive     = Float
    @value         = 0.1
    @other_value   = 0.2
    @invalid_value = '1'
  end

  include_examples 'A public Property'

  describe '.options' do
    subject { described_class.options }

    it { should be_kind_of(Hash) }

    it { should eql(:primitive => @primitive, :precision => 10, :scale => nil) }
  end
end
