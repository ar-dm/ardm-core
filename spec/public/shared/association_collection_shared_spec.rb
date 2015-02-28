RSpec.shared_examples_for 'It can transfer a Resource from another association' do
  before :all do
    @no_join = defined?(DataMapper::Adapters::InMemoryAdapter) && @adapter.kind_of?(DataMapper::Adapters::InMemoryAdapter) ||
               defined?(DataMapper::Adapters::YamlAdapter)     && @adapter.kind_of?(DataMapper::Adapters::YamlAdapter)

    @one_to_many  = @articles.kind_of?(DataMapper::Associations::OneToMany::Collection)
    @many_to_many = @articles.kind_of?(DataMapper::Associations::ManyToMany::Collection)

    skip if @no_join && @many_to_many
  end

  before :each do
    %w[ @resource @original ].each do |ivar|
      raise "+#{ivar}+ should be defined in before block" unless instance_variable_defined?(ivar)
      raise "+#{ivar}+ should not be nil in before block" unless instance_variable_get(ivar)
    end
  end

  it 'should remove the Resource from the original Collection' do
    pending
    @original.should_not include(@resource)
  end
end

RSpec.shared_examples_for 'A public Association Collection' do
  before :all do
    @no_join = defined?(DataMapper::Adapters::InMemoryAdapter) && @adapter.kind_of?(DataMapper::Adapters::InMemoryAdapter) ||
               defined?(DataMapper::Adapters::YamlAdapter)     && @adapter.kind_of?(DataMapper::Adapters::YamlAdapter)

    @one_to_many  = @articles.kind_of?(DataMapper::Associations::OneToMany::Collection)
    @many_to_many = @articles.kind_of?(DataMapper::Associations::ManyToMany::Collection)

    skip if @no_join && @many_to_many
  end

  before :each do
    %w[ @articles @other_articles ].each do |ivar|
      raise "+#{ivar}+ should be defined in before block" unless instance_variable_get(ivar)
    end

    @articles.loaded?.should == loaded
  end

  describe '#<<' do
    describe 'when provided a Resource belonging to another association' do
      before :each do
        @original = @other_articles
        @resource = @original.first

        @return = @articles << @resource
      end

      it 'should return a Collection' do
        @return.should be_kind_of(DataMapper::Collection)
      end

      it 'should return self' do
        @return.should equal(@articles)
      end

      include_examples 'It can transfer a Resource from another association'
    end
  end

  describe '#collect!' do
    describe 'when provided a Resource belonging to another association' do
      before :each do
        @original = @other_articles
        @resource = @original.first
        @return = @articles.collect! { |resource| @resource }
      end

      it 'should return a Collection' do
        @return.should be_kind_of(DataMapper::Collection)
      end

      it 'should return self' do
        @return.should equal(@articles)
      end

      include_examples 'It can transfer a Resource from another association'
    end
  end

  describe '#concat' do
    describe 'when provided a Resource belonging to another association' do
      before :each do
        @original = @other_articles
        @resource = @original.first

        @return = @articles.concat([ @resource ])
      end

      it 'should return a Collection' do
        @return.should be_kind_of(DataMapper::Collection)
      end

      it 'should return self' do
        @return.should equal(@articles)
      end

      include_examples 'It can transfer a Resource from another association'
    end
  end

  describe '#create' do
    describe 'when the parent is not saved' do
      it 'should raise an exception' do
        author = @author_model.new(:name => 'Dan Kubb')
        lambda {
          author.articles.create
        }.should raise_error(DataMapper::UnsavedParentError)
      end
    end
  end

  describe '#destroy' do
    describe 'when the parent is not saved' do
      it 'should raise an exception' do
        author = @author_model.new(:name => 'Dan Kubb')
        lambda {
          author.articles.destroy
        }.should raise_error(DataMapper::UnsavedParentError, 'The source must be saved before mass-deleting the collection')
      end
    end
  end

  describe '#destroy!' do
    describe 'when the parent is not saved' do
      it 'should raise an exception' do
        author = @author_model.new(:name => 'Dan Kubb')
        lambda {
          author.articles.destroy!
        }.should raise_error(DataMapper::UnsavedParentError, 'The source must be saved before mass-deleting the collection')
      end
    end
  end

  describe '#insert' do
    describe 'when provided a Resource belonging to another association' do
      before :each do
        @original = @other_articles
        @resource = @original.first

        @return = @articles.insert(0, @resource)
      end

      it 'should return a Collection' do
        @return.should be_kind_of(DataMapper::Collection)
      end

      it 'should return self' do
        @return.should equal(@articles)
      end

      include_examples 'It can transfer a Resource from another association'
    end
  end

  it 'should respond to a public collection method with #method_missing' do
    @articles.respond_to?(:to_a)
  end

  describe '#method_missing' do
    describe 'with a public collection method' do
      before :each do
        @return = @articles.to_a
      end

      it 'should return expected object' do
        @return.should == @articles
      end
    end

    describe 'with unknown method' do
      it 'should raise an exception' do
        lambda {
          @articles.unknown
        }.should raise_error(NoMethodError)
      end
    end
  end

  describe '#new' do
    before :each do
      @resource = @author.articles.new
    end

    it 'should associate the Resource to the Collection' do
      if @resource.respond_to?(:authors)
        pending 'TODO: make sure the association is bidirectional'
        @resource.authors.should == [ @author ]
      else
        @resource.author.should == @author
      end
    end
  end

  describe '#push' do
    describe 'when provided a Resource belonging to another association' do
      before :each do
        @original = @other_articles
        @resource = @original.first

        @return = @articles.push(@resource)
      end

      it 'should return a Collection' do
        @return.should be_kind_of(DataMapper::Collection)
      end

      it 'should return self' do
        @return.should equal(@articles)
      end

      include_examples 'It can transfer a Resource from another association'
    end
  end

  describe '#replace' do
    describe 'when provided a Resource belonging to another association' do
      before :each do
        @original = @other_articles
        @resource = @original.first

        @return = @articles.replace([ @resource ])
      end

      it 'should return a Collection' do
        @return.should be_kind_of(DataMapper::Collection)
      end

      it 'should return self' do
        @return.should equal(@articles)
      end

      include_examples 'It can transfer a Resource from another association'
    end
  end

  describe '#unshift' do
    describe 'when provided a Resource belonging to another association' do
      before :each do
        @original = @other_articles
        @resource = @original.first

        @return = @articles.unshift(@resource)
      end

      it 'should return a Collection' do
        @return.should be_kind_of(DataMapper::Collection)
      end

      it 'should return self' do
        @return.should equal(@articles)
      end

      include_examples 'It can transfer a Resource from another association'
    end
  end

  describe '#update' do
    describe 'when the parent is not saved' do
      it 'should raise an exception' do
        author = @author_model.new(:name => 'Dan Kubb')
        lambda {
          author.articles.update(:title => 'New Title')
        }.should raise_error(DataMapper::UnsavedParentError, 'The source must be saved before mass-updating the collection')
      end
    end
  end

  describe '#update!' do
    describe 'when the parent is not saved' do
      it 'should raise an exception' do
        author = @author_model.new(:name => 'Dan Kubb')
        lambda {
          author.articles.update!(:title => 'New Title')
        }.should raise_error(DataMapper::UnsavedParentError, 'The source must be saved before mass-updating the collection')
      end
    end
  end
end
