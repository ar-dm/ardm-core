require 'unit/data_mapper/ordered_set/shared/entries_spec'

shared_examples_for 'DataMapper::SubjectSet#entries with no entries' do
  include_examples 'DataMapper::OrderedSet#entries with no entries'
end

shared_examples_for 'DataMapper::SubjectSet#entries with entries' do
  include_examples 'DataMapper::OrderedSet#entries with entries'
end
