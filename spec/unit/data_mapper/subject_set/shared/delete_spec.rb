require 'unit/data_mapper/ordered_set/shared/delete_spec'

shared_examples_for 'DataMapper::SubjectSet#delete when deleting an already included entry' do
  include_examples 'DataMapper::OrderedSet#delete when deleting an already included entry'
end

shared_examples_for 'DataMapper::SubjectSet#delete when deleting a not yet included entry' do
  include_examples 'DataMapper::OrderedSet#delete when deleting a not yet included entry'
end
