require 'spec_helper'
require 'dm-core/support/ordered_set'
require 'unit/data_mapper/ordered_set/shared/size_spec'

describe 'DataMapper::OrderedSet#size' do
  subject { ordered_set.size }

  context 'when no entry is present' do
    let(:ordered_set) { DataMapper::OrderedSet.new }

    include_examples 'DataMapper::OrderedSet#size when no entry is present'
  end

  context 'when 1 entry is present' do
    let(:ordered_set) { DataMapper::OrderedSet.new([ 1 ]) }

    include_examples 'DataMapper::OrderedSet#size when 1 entry is present'
  end

  context 'when more than 1 entry is present' do
    let(:ordered_set)   { DataMapper::OrderedSet.new(entries) }
    let(:entries)       { [ 1, 2 ]                            }
    let(:expected_size) { entries.size                        }

    include_examples 'DataMapper::OrderedSet#size when more than 1 entry is present'
  end
end
