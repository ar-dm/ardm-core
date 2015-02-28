require 'spec_helper'
require 'dm-core/spec/shared/adapter_spec'

describe 'Adapter' do
  supported_by :in_memory do
    describe 'DataMapper::Adapters::InMemoryAdapter' do

      include_examples 'An Adapter'

    end
  end
end
