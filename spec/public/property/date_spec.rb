require 'spec_helper'

describe DataMapper::Property::Date do
  before :each do
    @name          = :created_on
    @type          = described_class
    @primitive     = Date
    @value         = Date.today
    @other_value   = Date.today + 1
    @invalid_value = 1
  end

  include_examples 'A public Property'

  describe '.options' do
    subject { described_class.options }

    it { should be_kind_of(Hash) }

    it { should eql(:primitive => @primitive) }
  end
end
