require 'spec_helper'
require 'dm-core/support/subject_set'
require 'unit/data_mapper/subject_set/shared/delete_spec'

describe 'DataMapper::SubjectSet#delete' do
  before :all do

    class ::Person
      attr_reader :name
      def initialize(name)
        @name = name
      end
    end

  end

  subject { set }

  let(:set)         { DataMapper::SubjectSet.new([ entry1, entry2, entry3 ]) }
  let(:ordered_set) { set.entries                                            }
  let(:entry1)      { Person.new('Alice')                                    }
  let(:entry2)      { Person.new('John' )                                    }
  let(:entry3)      { Person.new('Jane' )                                    }

  before do
    set.delete(entry)
  end

  context 'when deleting an already included entry' do
    let(:entry) { entry1 }

    include_examples 'DataMapper::SubjectSet#delete when deleting an already included entry'
  end

  context 'when deleting a not yet included entry' do
    let(:entry) { Person.new('Bob') }

    include_examples 'DataMapper::SubjectSet#delete when deleting a not yet included entry'
  end
end
