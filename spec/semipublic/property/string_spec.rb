require 'spec_helper'

describe DataMapper::Property::String do
  before :each do
    @name          = :name
    @type          = described_class
    @value         = 'value'
    @other_value   = 'return value'
    @invalid_value = 1
  end

  include_examples 'A semipublic Property'
end
