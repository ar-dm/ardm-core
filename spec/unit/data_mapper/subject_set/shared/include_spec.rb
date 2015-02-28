require 'unit/data_mapper/ordered_set/shared/include_spec'

shared_examples_for 'DataMapper::SubjectSet#include? when the entry is present' do
  include_examples 'DataMapper::OrderedSet#include? when the entry is present'
end

shared_examples_for 'DataMapper::SubjectSet#include? when the entry is not present' do
  include_examples 'DataMapper::OrderedSet#include? when the entry is not present'
end
