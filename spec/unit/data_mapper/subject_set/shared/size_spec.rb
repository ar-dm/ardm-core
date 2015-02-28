require 'unit/data_mapper/ordered_set/shared/size_spec'

shared_examples_for 'DataMapper::SubjectSet#size when no entry is present' do
  include_examples 'DataMapper::OrderedSet#size when no entry is present'
end

shared_examples_for 'DataMapper::SubjectSet#size when 1 entry is present' do
  include_examples 'DataMapper::OrderedSet#size when 1 entry is present'
end

shared_examples_for 'DataMapper::SubjectSet#size when more than 1 entry is present' do
  include_examples 'DataMapper::OrderedSet#size when more than 1 entry is present'
end
