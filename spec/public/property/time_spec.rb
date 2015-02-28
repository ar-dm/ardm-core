require 'spec_helper'

describe DataMapper::Property::Time do
  before :each do
    @name          = :deleted_at
    @type          = described_class
    @primitive     = Time
    @value         = Time.now
    @other_value   = Time.now + 15
    @invalid_value = 1
  end

  include_examples 'A public Property'

  describe '.options' do
    subject { described_class.options }

    it { should be_kind_of(Hash) }

    it { should eql(:primitive => @primitive) }
  end
end
