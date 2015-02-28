require 'spec_helper'

describe DataMapper::Property::Serial do
  before :each do
    @name          = :id
    @type          = described_class
    @value         = 1
    @other_value   = 2
    @invalid_value = 'foo'
  end

  include_examples 'A semipublic Property'
end
