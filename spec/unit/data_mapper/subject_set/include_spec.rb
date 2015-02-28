require 'spec_helper'
require 'dm-core/support/subject_set'
require 'unit/data_mapper/subject_set/shared/include_spec'

describe 'DataMapper::SubjectSet#include?' do
  before :all do

    class ::Person
      attr_reader :name
      def initialize(name)
        @name = name
      end
    end

  end

  subject { set.include?(entry) }

  let(:entry) { Person.new('Alice') }

  context 'when the entry is present' do
    let(:set) { DataMapper::SubjectSet.new([ entry ]) }

    include_examples 'DataMapper::SubjectSet#include? when the entry is present'
  end

  context 'when the entry is not present' do
    let(:set) { DataMapper::SubjectSet.new }

    include_examples 'DataMapper::SubjectSet#include? when the entry is not present'
  end
end
