require 'spec_helper'

describe DataMapper::Property::Binary do
  before :each do
    @name          = :title
    @type          = described_class
    @value         = 'value'
    @other_value   = 'return value'
    @invalid_value = 1
  end

  include_examples 'A semipublic Property'
end
