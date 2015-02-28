require 'spec_helper'
require 'dm-core/support/subject_set'
require 'unit/data_mapper/subject_set/shared/each_spec'

describe 'DataMapper::SubjectSet' do
  subject { DataMapper::SubjectSet.new }

  include_examples 'DataMapper::SubjectSet'
end

describe 'DataMapper::SubjectSet#each' do
  before :all do

    class ::Person
      attr_reader :name
      def initialize(name)
        @name = name
      end
    end

  end

  subject { set.each { |entry| yields << entry } }

  let(:set)    { DataMapper::SubjectSet.new([ entry ]) }
  let(:entry)  { Person.new('Alice')                   }
  let(:yields) { []                                    }

  include_examples 'DataMapper::SubjectSet#each'
end
