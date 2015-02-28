require 'unit/data_mapper/ordered_set/shared/each_spec'

shared_examples_for 'DataMapper::SubjectSet' do
  include_examples 'DataMapper::OrderedSet'
end

shared_examples_for 'DataMapper::SubjectSet#each' do
  include_examples 'DataMapper::OrderedSet#each'
end
