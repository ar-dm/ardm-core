require 'spec_helper'
require 'dm-core/support/ordered_set'
require 'unit/data_mapper/ordered_set/shared/initialize_spec'

describe 'DataMapper::OrderedSet#initialize' do

  context 'when no entries are given' do
    subject { DataMapper::OrderedSet.new }

    include_examples 'DataMapper::OrderedSet#initialize when no entries are given'
  end

  context 'when entries are given' do
    subject { DataMapper::OrderedSet.new(entries) }

    context 'and they do not contain duplicates' do
      let(:entries) { [ entry1, entry2 ] }
      let(:entry1)  { 1                  }
      let(:entry2)  { 2                  }

      include_examples 'DataMapper::OrderedSet#initialize when entries are given and they do not contain duplicates'
    end

    context 'and they contain duplicates' do
      let(:entries) { [ entry1, entry2 ] }
      let(:entry1)  { 1                  }
      let(:entry2)  { 1                  }

      include_examples 'DataMapper::OrderedSet#initialize when entries are given and they contain duplicates'
    end
  end
end
