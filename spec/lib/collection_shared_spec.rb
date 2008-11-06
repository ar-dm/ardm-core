share_examples_for 'A Collection' do
  before do
    %w[ @model @article @other @articles @other_articles ].each do |ivar|
      raise "+#{ivar}+ should be defined in before block" unless instance_variable_get(ivar)
    end
  end

  it 'should respond to #<<' do
    @articles.should respond_to(:<<)
  end

  describe '#<<' do
    before do
      @resource = @model.new(:title => 'Title')
      @return = @articles << @resource
    end

    it 'should return a Collection' do
      @return.should be_kind_of(DataMapper::Collection)
    end

    it 'should return self' do
      @return.should be_equal(@articles)
    end

    it 'should append one Resource to the Collection' do
      @articles.last.should be_equal(@resource)
    end

    it 'should relate the Resource to the Collection' do
      @resource.collection.should be_equal(@articles)
    end
  end

  it 'should respond to #all' do
    @articles.should respond_to(:all)
  end

  describe '#all' do
    describe 'with no arguments' do
      before do
        @return = @articles.all
      end

      it 'should return a Collection' do
        @return.should be_kind_of(DataMapper::Collection)
      end

      it 'should return self' do
        @return.should be_equal(@articles)
      end
    end

    describe 'with a query' do
      before do
        @return = @articles.all(:limit => 10).all(:limit => 1)
      end

      it 'should return a Collection' do
        @return.should be_kind_of(DataMapper::Collection)
      end

      it 'should return a new Collection' do
        @return.should_not be_equal(@articles)
      end

      it 'should have a different query than original Collection' do
        @return.query.should_not == @articles.query
      end

      it 'is empty when passed an offset that is out of range' do
        pending 'TODO: handle out of range offsets in Collection' do
          empty_collection = @return.all(:offset => 10)
          empty_collection.should == []
          empty_collection.should be_loaded
        end
      end
    end
  end

  it 'should respond to #at' do
    @articles.should respond_to(:at)
  end

  describe '#at' do
    describe 'with positive offset' do
      before do
        @return = @resource = @articles.at(0)
      end

      it 'should return a Resource' do
        @return.should be_kind_of(DataMapper::Resource)
      end

      it 'should lookup the Resource by offset' do
        @return.key.should == @article.key
      end
    end

    describe 'with negative offset' do
      before do
        @return = @resource = @articles.at(-1)
      end

      it 'should return a Resource' do
        @return.should be_kind_of(DataMapper::Resource)
      end

      it 'should return the expected Resource' do
        @return.key.should == @article.key
      end
    end
  end

  it 'should respond to #build' do
    @articles.should respond_to(:build)
  end

  describe '#build' do
    before do
      skip_class = DataMapper::Associations::ManyToMany::Proxy
      pending_if "TODO: implement #{skip_class}#build", @articles.kind_of?(skip_class) do
        @return = @resource = @articles.build(:content => 'Content')
      end
    end

    it 'should return a Resource' do
      @return.should be_kind_of(DataMapper::Resource)
    end

    it 'should be a Resource with expected attributes' do
      @resource.attributes.only(:content).should == { :content => 'Content' }
    end

    it 'should be a new Resource' do
      @resource.should be_new_record
    end

    it 'should append the Resource to the Collection' do
      @articles.last.should be_equal(@resource)
    end

    it 'should use the query conditions to set default values' do
      @resource.attributes.only(:title).should == { :title => 'Sample Article' }
    end
  end

  it 'should respond to #clear' do
    @articles.should respond_to(:clear)
  end

  describe '#clear' do
    before do
      @resources = @articles.entries
      @return = @articles.clear
    end

    it 'should return a Collection' do
      @return.should be_kind_of(DataMapper::Collection)
    end

    it 'should return self' do
      @return.should be_equal(@articles)
    end

    it 'should make the Collection empty' do
      @articles.should be_empty
    end

    it 'should orphan the Resources' do
      @resources.each { |r| r.collection.should_not be_equal(@articles) }
    end
  end

  [ :collect!, :map! ].each do |method|
    it "should respond to ##{method}" do
      @articles.should respond_to(method)
    end

    describe "##{method}" do
      before do
        @resources = @articles.entries
        @return = @articles.send(method) { |r| @model.new(:title => 'Title') }
      end

      it 'should return a Collection' do
        @return.should be_kind_of(DataMapper::Collection)
      end

      it 'should return self' do
        @return.should be_equal(@articles)
      end

      it 'should update the Collection inline' do
        @articles.should == [ @model.new(:title => 'Title') ]
      end

      it 'should orphan each replaced Resource in the Collection' do
        @resources.each { |r| r.collection.should_not be_equal(@articles) }
      end
    end
  end

  it 'should respond to #concat' do
    @articles.should respond_to(:concat)
  end

  describe '#concat' do
    before do
      @resources = @other_articles.entries
      @return = @articles.concat(@other_articles)
    end

    it 'should return a Collection' do
      @return.should be_kind_of(DataMapper::Collection)
    end

    it 'should return self' do
      @return.should be_equal(@articles)
    end

    it 'should concatenate the two collections' do
      @return.should == [ @article, @other ]
    end

    it 'should relate each Resource to the Collection' do
      @resources.each { |r| r.collection.should be_equal(@articles) }
    end
  end

  it 'should respond to #create' do
    @articles.should respond_to(:create)
  end

  describe '#create' do
    before do
      skip_class = DataMapper::Associations::ManyToMany::Proxy
      pending_if "TODO: implement #{skip_class}#create", @articles.kind_of?(skip_class) do
        @return = @resource = @articles.create(:content => 'Content')
      end
    end

    it 'should return a Resource' do
      @return.should be_kind_of(DataMapper::Resource)
    end

    it 'should be a Resource with expected attributes' do
      @resource.attributes.only(:content).should == { :content => 'Content' }
    end

    it 'should be a saved Resource' do
      @resource.should_not be_new_record
    end

    it 'should append the Resource to the Collection' do
      @articles.last.should be_equal(@resource)
    end

    it 'should use the query conditions to set default values' do
      @resource.attributes.only(:title).should == { :title => 'Sample Article' }
    end

    it 'should not append a Resource if create fails' do
      pending 'TODO: not sure how to best spec this'
    end
  end

  it 'should respond to #delete' do
    @articles.should respond_to(:delete)
  end

  describe '#delete' do
    describe 'with a Resource within the Collection' do
      before do
        @return = @resource = @articles.delete(@article)
      end

      it 'should return a DataMapper::Resource' do
        @return.should be_kind_of(DataMapper::Resource)
      end

      it 'should be the expected Resource' do
        @resource.should == @article
      end

      it 'should remove the Resource from the Collection' do
        @articles.should_not include(@resource)
      end

      it 'should orphan the Resource' do
        @resource.collection.should_not be_equal(@articles)
      end
    end

    describe 'with a Resource not within the Collection' do
      before do
        @return = @articles.delete(@other)
      end

      it 'should return nil' do
        @return.should be_nil
      end
    end
  end

  it 'should respond to #delete_at' do
    @articles.should respond_to(:delete_at)
  end

  describe '#delete_at' do
    describe 'with an index within the Collection' do
      before do
        @return = @resource = @articles.delete_at(0)
      end

      it 'should return a DataMapper::Resource' do
        @return.should be_kind_of(DataMapper::Resource)
      end

      it 'should be the expected Resource' do
        @resource.should == @article
      end

      it 'should remove the Resource from the Collection' do
        @articles.should_not include(@resource)
      end

      it 'should orphan the Resource' do
        @resource.collection.should_not be_equal(@articles)
      end
    end

    describe 'with an index not within the Collection' do
      before do
        @return = @articles.delete_at(1)
      end

      it 'should return nil' do
        @return.should be_nil
      end
    end
  end

  it 'should respond to #delete_if' do
    @articles.should respond_to(:delete_if)
  end

  describe '#delete_if' do

    describe 'with a block that matches a Resource in the Collection' do
      before do
        @resources = @articles.entries
        @return = @articles.delete_if { true }
      end

      it 'should return a Collection' do
        @return.should be_kind_of(DataMapper::Collection)
      end

      it 'should return self' do
        @return.should be_equal(@articles)
      end

      it 'should remove the Resources from the Collection' do
        @resources.each { |r| @articles.should_not include(r) }
      end

      it 'should orphan the Resources' do
        @resources.each { |r| r.collection.should_not be_equal(@articles) }
      end
    end

    describe 'with a block that does not match a Resource in the Collection' do
      before do
        @resources = @articles.entries
        @return = @articles.delete_if { false }
      end

      it 'should return a Collection' do
        @return.should be_kind_of(DataMapper::Collection)
      end

      it 'should return self' do

        @return.should be_equal(@articles)
      end

      it 'should not modify the Collection' do
        @articles.should == @resources
      end
    end
  end

  it 'should respond to #destroy' do
    @articles.should respond_to(:destroy)
  end

  describe '#destroy' do
    before do
      pending 'TODO: implement DataMapper::Collection#destroy' do
        @return = @articles.destroy
      end
    end

    it 'should return true' do
      @return.should be_true
    end

    it 'should remove the Resources from the datasource' do
      @model.all(:title => 'Sample Article').should be_empty
    end

    it 'should clear the collection' do
      @articles.should be_empty
    end
  end

  it 'should respond to #destroy!' do
    @articles.should respond_to(:destroy!)
  end

  describe '#destroy!' do
    before do
      @skip_class = DataMapper::Associations::ManyToMany::Proxy
      pending_if "TODO: override #{@skip_class}#destroy! from the OneToMany proxy", @articles.kind_of?(@skip_class) && !@adapter.kind_of?(DataMapper::Adapters::InMemoryAdapter) do
        @return = @articles.destroy!
      end
    end

    it 'should return true' do
      @return.should be_true
    end

    it 'should remove the Resources from the datasource' do
      pending_if "TODO: override #{@skip_class}#destroy! from the OneToMany proxy", @articles.kind_of?(@skip_class) do
        @model.all(:title => 'Sample Article').should be_empty
      end
    end

    it 'should clear the collection' do
      @articles.should be_empty
    end

    it 'should bypass validation' do
      pending 'TODO: not sure how to best spec this'
    end
  end

  it 'should respond to #first' do
    @articles.should respond_to(:first)
  end

  describe '#first' do
    describe 'with no arguments' do
      before do
        @return = @resource = @articles.first
      end

      it 'should return a Resource' do
        @return.should be_kind_of(DataMapper::Resource)
      end

      it 'should be first Resource in the Collection' do
        @resource.should == @article
      end

      it 'should relate the Resource to the Collection' do
        @resource.collection.should be_equal(@articles)
      end
    end

    describe 'with no arguments', 'after prepending to the collection' do
      before do
        @articles.unshift(@other)
        @return = @resource = @articles.first
      end

      it 'should return a Resource' do
        @return.should be_kind_of(DataMapper::Resource)
      end

      it 'should be first Resource in the Collection' do
        @resource.should be_equal(@other)
      end

      it 'should relate the Resource to the Collection' do
        @resource.collection.should be_equal(@articles)
      end
    end

    describe 'with a query' do
      before do
        @skip_class = DataMapper::Associations::ManyToMany::Proxy
        @return = @resource = @articles.first(:content => 'Sample')
      end

      it 'should return a Resource' do
        pending_if "TODO: #{@skip_class}#first needs love", @articles.kind_of?(@skip_class) do
          @return.should be_kind_of(DataMapper::Resource)
        end
      end

      it 'should should be the first Resource in the Collection matching the query' do
        pending_if "TODO: #{@skip_class}#first needs love", @articles.kind_of?(@skip_class) do
          @resource.should == @article
        end
      end

      it 'should relate the Resource to the Collection' do
        skip_class = DataMapper::Associations::OneToMany::Proxy
        pending_if "TODO: update #{skip_class}#first to relate the resource to the Proxy not the underlying Collection", @articles.kind_of?(skip_class) do
          @resource.collection.should be_equal(@articles)
        end
      end
    end

    describe 'with limit specified' do
      before do
        @return = @resources = @articles.first(1)
      end

      it 'should return a Collection' do
        @return.should be_kind_of(DataMapper::Collection)
      end

      it 'should be the first N Resources in the Collection' do
        @resources.should == [ @article ]
      end

      it 'should orphan the Resources' do
        @resources.each { |r| r.collection.should_not be_equal(@articles) }
      end
    end

    describe 'with limit specified', 'after prepending to the collection' do
      before do
        @articles.unshift(@other)
        @return = @resources = @articles.first(1)
      end

      it 'should return a Collection' do
        @return.should be_kind_of(DataMapper::Collection)
      end

      it 'should be the first N Resources in the Collection' do
        @resources.should == [ @other ]
      end

      it 'should orphan the Resources' do
        @resources.each { |r| r.collection.should_not be_equal(@articles) }
      end
    end

    describe 'with limit and query specified' do
      before do
        @return = @resources = @articles.first(1, :content => 'Sample')
      end

      it 'should return a Collection' do
        @return.should be_kind_of(DataMapper::Collection)
      end

      it 'should be the first N Resources in the Collection matching the query' do
        skip_class = DataMapper::Associations::ManyToMany::Proxy
        pending_if "TODO: #{skip_class}#first needs love", @articles.kind_of?(skip_class) do
          @resources.should == [ @article ]
        end
      end

      it 'should orphan the Resources' do
        @resources.each { |r| r.collection.should_not be_equal(@articles) }
      end
    end
  end

  it 'should respond to #get' do
    @articles.should respond_to(:get)
  end

  describe '#get' do
    describe 'with a key to a Resource within the Collection' do
      before do
        @return = @resource = @articles.get(1)
      end

      it 'should return a Resource' do
        @return.should be_kind_of(DataMapper::Resource)
      end

      it 'should be matching Resource in the Collection' do
        @resource.should == @article
      end
    end

    describe 'with a key to a Resource not within the Collection' do
      before do
        @return = @articles.get(99)
      end

      it 'should return nil' do
        @return.should be_nil
      end
    end

    describe 'with a key not typecast' do
      before do
        @return = @resource = @articles.get('1')
      end

      it 'should return a Resource' do
        @return.should be_kind_of(DataMapper::Resource)
      end

      it 'should be matching Resource in the Collection' do
        @resource.should == @article
      end
    end

    describe 'with a key to a Resource within a Collection using a limit' do
      before do
        @articles = Article.all(:limit => 1)
        @return = @resource = @articles.get(1)
      end

      it 'should return a Resource' do
        @return.should be_kind_of(DataMapper::Resource)
      end

      it 'should be matching Resource in the Collection' do
        @resource.should == @article
      end
    end

    describe 'with a key to a Resource within a Collection using an offset' do
      before do
        @articles = Article.all(:offset => 1, :limit => 1)
        @return = @resource = @articles.get(2)
      end

      it 'should return a Resource' do
        @return.should be_kind_of(DataMapper::Resource)
      end

      it 'should be matching Resource in the Collection' do
        @resource.should == @other
      end
    end
  end

  it 'should respond to #get!' do
    @articles.should respond_to(:get!)
  end

  describe '#get!' do
    describe 'with a key to a Resource within the Collection' do
      before do
        @return = @resource = @articles.get!(1)
      end

      it 'should return a Resource' do
        @return.should be_kind_of(DataMapper::Resource)
      end

      it 'should be matching Resource in the Collection' do
        @resource.should == @article
      end
    end

    describe 'with a key to a Resource not within the Collection' do
      it 'should raise an exception' do
        lambda {
          @articles.get!(99)
        }.should raise_error(DataMapper::ObjectNotFoundError, 'Could not find Article with key [99] in collection')
      end
    end

    describe 'with a key not typecast' do
      before do
        @return = @resource = @articles.get!('1')
      end

      it 'should return a Resource' do
        @return.should be_kind_of(DataMapper::Resource)
      end

      it 'should be matching Resource in the Collection' do
        @resource.should == @article
      end
    end
  end

  it 'should respond to #insert' do
    @articles.should respond_to(:insert)
  end

  describe '#insert' do
    before do
      @resources = @other_articles
      @return = @articles.insert(0, *@resources)
    end

    it 'should return a Collection' do
      @return.should be_kind_of(DataMapper::Collection)
    end

    it 'should return self' do
      @return.should be_equal(@articles)
    end

    it 'should insert one or more Resources at a given index' do
      @articles.should == @resources + [ @article ]
    end

    it 'should relate the Resources to the Collection' do
      @resources.each { |r| r.collection.should be_equal(@articles) }
    end
  end

  it 'should respond to #last' do
    @articles.should respond_to(:last)
  end

  describe '#last' do
    describe 'with no arguments' do
      before do
        @return = @resource = @articles.last
      end

      it 'should return a Resource' do
        @return.should be_kind_of(DataMapper::Resource)
      end

      it 'should be last Resource in the Collection' do
        @resource.should == @article
      end

      it 'should relate the Resource to the Collection' do
        @resource.collection.should be_equal(@articles)
      end
    end

    describe 'with no arguments', 'after prepending to the collection' do
      before do
        @articles.push(@other)
        @return = @resource = @articles.last
      end

      it 'should return a Resource' do
        @return.should be_kind_of(DataMapper::Resource)
      end

      it 'should be last Resource in the Collection' do
        @resource.should be_equal(@other)
      end

      it 'should relate the Resource to the Collection' do
        @resource.collection.should be_equal(@articles)
      end
    end

    describe 'with a query' do
      before do
        @skip_class = DataMapper::Associations::ManyToMany::Proxy
        @return = @resource = @articles.last(:content => 'Sample')
      end

      it 'should return a Resource' do
        pending_if "TODO: #{@skip_class}#last needs love", @articles.kind_of?(@skip_class) do
          @return.should be_kind_of(DataMapper::Resource)
        end
      end

      it 'should should be the last Resource in the Collection matching the query' do
        pending_if "TODO: #{@skip_class}#last needs love", @articles.kind_of?(@skip_class) do
          @resource.should == @article
        end
      end

      it 'should relate the Resource to the Collection' do
        pending_if "TODO: #{@skip_class}#last needs love", @articles.kind_of?(@skip_class) do
          @resource.collection.should be_equal(@articles)
        end
      end
    end

    describe 'with limit specified' do
      before do
        @return = @resources = @articles.last(1)
      end

      it 'should return a Collection' do
        @return.should be_kind_of(DataMapper::Collection)
      end

      it 'should be the last N Resources in the Collection' do
        @resources.should == [ @article ]
      end

      it 'should orphan the Resources' do
        @resources.each { |r| r.collection.should_not be_equal(@articles) }
      end
    end

    describe 'with limit specified', 'after prepending to the collection' do
      before do
        @articles.push(@other)
        @return = @resources = @articles.last(1)
      end

      it 'should return a Collection' do
        @return.should be_kind_of(DataMapper::Collection)
      end

      it 'should be the last N Resources in the Collection' do
        @resources.should == [ @other ]
      end

      it 'should orphan the Resources' do
        @resources.each { |r| r.collection.should_not be_equal(@articles) }
      end
    end

    describe 'with limit and query specified' do
      before do
        @return = @resources = @articles.last(1, :content => 'Sample')
      end

      it 'should return a Collection' do
        @return.should be_kind_of(DataMapper::Collection)
      end

      it 'should be the last N Resources in the Collection matching the query' do
        skip_class = DataMapper::Associations::ManyToMany::Proxy
        pending_if "TODO: #{skip_class}#last needs love", @articles.kind_of?(skip_class) do
          @resources.should == [ @article ]
        end
      end

      it 'should orphan the Resources' do
        @resources.each { |r| r.collection.should_not be_equal(@articles) }
      end
    end
  end

  it 'should respond to #pop' do
    @articles.should respond_to(:pop)
  end

  describe '#pop' do
    before do
       @new_article = @model.create(:title => 'Sample Article')
       @articles << @new_article if @articles.loaded?
       @return = @resource = @articles.pop
    end

    it 'should return a Resource' do
      @return.should be_kind_of(DataMapper::Resource)
    end

    it 'should be the last Resource in the Collection' do
      @resource.should == @new_article
    end

    it 'should remove the Resource from the Collection' do
      @articles.should_not include(@resource)
    end

    it 'should orphan the Resource' do
      @resource.collection.should_not be_equal(@articles)
    end
  end

  it 'should respond to #push' do
    @articles.should respond_to(:push)
  end

  describe '#push' do
    before do
      @resources = [ @model.new(:title => 'Title 1'), @model.new(:title => 'Title 2') ]
      @return = @articles.push(*@resources)
    end

    it 'should return a Collection' do
      @return.should be_kind_of(DataMapper::Collection)
    end

    it 'should return self' do
      @return.should be_equal(@articles)
    end

    it 'should append the Resources to the Collection' do
      @articles.should == [ @article ] + @resources
    end

    it 'should relate the Resources to the Collection' do
      @resources.each { |r| r.collection.should be_equal(@articles) }
    end
  end

  it 'should respond to #reject!' do
    @articles.should respond_to(:reject!)
  end

  describe '#reject!' do
    describe 'with a block that matches a Resource in the Collection' do
      before do
        @resources = @articles.entries
        @return = @articles.reject! { true }
      end

      it 'should return a Collection' do
        @return.should be_kind_of(DataMapper::Collection)
      end

      it 'should return self' do
        @return.should be_equal(@articles)
      end

      it 'should remove the Resources from the Collection' do
        @resources.each { |r| @articles.should_not include(r) }
      end

      it 'should orphan the Resources' do
        @resources.each { |r| r.collection.should_not be_equal(@articles) }
      end
    end

    describe 'with a block that does not match a Resource in the Collection' do
      before do
        @resources = @articles.entries
        @return = @articles.reject! { false }
      end

      it 'should return nil' do
        @return.should == nil
      end

      it 'should not modify the Collection' do
        @articles.should == @resources
      end
    end
  end

  it 'should respond to #reload' do
    @articles.should respond_to(:reload)
  end

  describe '#reload' do
    describe 'with no arguments' do
      before do
        @resources = @articles.entries
        @return = @collection = @articles.reload
      end

      it 'should return a Collection' do
        @return.should be_kind_of(DataMapper::Collection)
      end

      it 'should return self' do
        @return.should be_equal(@articles)
      end

      it 'should update the Collection' do
        skip_class = DataMapper::Associations::ManyToMany::Proxy
        pending_if "TODO: Fix #{skip_class}#reload", @articles.kind_of?(skip_class) do
          pending "TODO: Fix Query#update to copy other.repository to @repository" do
            @articles.each_with_index { |r,i| r.should_not be_equal(@resources[i]) }
          end
        end
      end

      it 'should have non-lazy query fields loaded' do
        @return.each { |r| { :title => true, :content => false }.each { |a,c| r.attribute_loaded?(a).should == c } }
      end
    end

    describe 'with a query' do
      before do
        @resources = @articles.entries
        @return = @collection = @articles.reload(:fields => [ :title, :content ])
      end

      it 'should return a Collection' do
        @return.should be_kind_of(DataMapper::Collection)
      end

      it 'should return self' do
        @return.should be_equal(@articles)
      end

      it 'should update the Collection' do
        skip_class = DataMapper::Associations::ManyToMany::Proxy
        pending_if "TODO: Fix #{skip_class}#reload", @articles.kind_of?(skip_class) do
          pending "TODO: Fix Query#update to copy other.repository to @repository" do
            @articles.each_with_index { |r,i| r.should_not be_equal(@resources[i]) }
          end
        end
      end

      it 'should have all query fields loaded' do
        @return.each { |r| { :title => true, :content => true }.each { |a,c| r.attribute_loaded?(a).should == c } }
      end
    end
  end

  it 'should respond to #replace' do
    @articles.should respond_to(:replace)
  end

  describe '#replace' do
    before do
      @resources = @articles.entries
      @return = @articles.replace(@other_articles)
    end

    it 'should return a Collection' do
      @return.should be_kind_of(DataMapper::Collection)
    end

    it 'should return self' do
      @return.should be_equal(@articles)
    end

    it 'should update the Collection with new Resources' do
      @articles.should == @other_articles
    end

    it 'should relate each Resource added to the Collection' do
      @articles.each { |r| r.collection.should be_equal(@articles) }
    end

    it 'should orphan each Resource removed from the Collection' do
      @resources.each { |r| r.collection.should_not be_equal(@articles) }
    end
  end

  it 'should respond to #reverse' do
    @articles.should respond_to(:reverse)
  end

  describe '#reverse' do
    before do
      @new_article = @model.create(:title => 'Sample Article')
      @articles << @new_article if @articles.loaded?
      @return = @articles.reverse
    end

    it 'should return a Collection' do
      @return.should be_kind_of(DataMapper::Collection)
    end

    it 'should return a Collection with reversed entries' do
      @return.should == [ @new_article, @article ]
    end
  end

  it 'should respond to #shift' do
    @articles.should respond_to(:shift)
  end

  describe '#shift' do
    before do
      @new_article = @model.create(:title => 'Sample Article')
      @articles << @new_article if @articles.loaded?
      @return = @resource = @articles.shift
    end

    it 'should return a Resource' do
      @return.should be_kind_of(DataMapper::Resource)
    end

    it 'should be the first Resource in the Collection' do
      @resource.should == @article
    end

    it 'should remove the Resource from the Collection' do
      @articles.should_not include(@resource)
    end

    it 'should orphan the Resource' do
      @resource.collection.should_not be_equal(@articles)
    end
  end

  [ :slice, :[] ].each do |method|
    it "should respond to ##{method}" do
      @articles.should respond_to(method)
    end

    describe "##{method}" do
      describe 'with an index' do
        before do
          @return = @resource = @articles.send(method, 0)
        end

        it 'should return a Resource' do
          @return.should be_kind_of(DataMapper::Resource)
        end

        it 'should return expected Resource' do
          @return.should == @article
        end

        it 'should relate the Resource to the Collection' do
          @resource.collection.should be_equal(@articles)
        end
      end

      describe 'with an offset and length' do
        before do
          @return = @resources = @articles.send(method, 0, 1)
        end

        it 'should return a Collection' do
          @return.should be_kind_of(DataMapper::Collection)
        end

        it 'should return the expected Resource' do
          skip_class = DataMapper::Associations::ManyToMany::Proxy
          pending_if "TODO: override #{skip_class}#slice", @articles.kind_of?(skip_class) do
            @return.should == [ @article ]
          end
        end

        it 'should orphan the Resources' do
          @resources.each { |r| r.collection.should_not be_equal(@articles) }
        end
      end

      describe 'with a range' do
        before do
          @return = @resources = @articles.send(method, 0..0)
        end

        it 'should return a Collection' do
          @return.should be_kind_of(DataMapper::Collection)
        end

        it 'should return the expected Resource' do
          skip_class = DataMapper::Associations::ManyToMany::Proxy
          pending_if "TODO: override #{skip_class}#slice", @articles.kind_of?(skip_class) do
            @return.should == [ @article ]
          end
        end

        it 'should orphan the Resources' do
          @resources.each { |r| r.collection.should_not be_equal(@articles) }
        end
      end

      describe 'with invalid arguments' do
        it 'should raise an exception' do
          lambda {
            @articles.send(method, Object.new)
          }.should raise_error(ArgumentError)
        end
      end
    end
  end

  it 'should respond to #slice!' do
    @articles.should respond_to(:slice)
  end

  describe '#slice!' do
    describe 'with an index' do
      before do
        @return = @resource = @articles.slice!(0)
      end

      it 'should return a Resource' do
        @return.should be_kind_of(DataMapper::Resource)
      end

      it 'should return expected Resource' do
        @return.should == @article
      end

      it 'should remove the Resource from the Collection' do
        @articles.should_not include(@resource)
      end

      it 'should orphan the Resource' do
        @resource.collection.should_not be_equal(@articles)
      end
    end

    describe 'with an offset and length' do
      before do
        @resources = @articles.entries
        @return = @articles.slice!(0, 1)
      end

      it 'should return an Array' do
        @return.should be_kind_of(Array)
      end

      it 'should return the expected Resource' do
        @return.should == @resources
      end

      it 'should remove the Resources from the Collection' do
        @resources.each { |r| @articles.should_not include(r) }
      end

      it 'should orphan the Resources' do
        @resources.each { |r| r.collection.should_not be_equal(@articles) }
      end
    end

    describe 'with a range' do
      before do
        @resources = @articles.entries
        @return = @articles.slice!(0..0)
      end

      it 'should return an Array' do
        @return.should be_kind_of(Array)
      end

      it 'should return the expected Resource' do
        @return.should == @resources
      end

      it 'should remove the Resources from the Collection' do
        @resources.each { |r| @articles.should_not include(r) }
      end

      it 'should orphan the Resources' do
        @resources.each { |r| r.collection.should_not be_equal(@articles) }
      end
    end

    describe 'with an index not within the Collection' do
      before do
        @return = @articles.slice!(1)
      end

      it 'should return nil' do
        @return.should be_nil
      end
    end

    describe 'with an offset and length not within the Collection' do
      before do
        # NOTE: Array#slice!(1, 1) returns [], but should be nil.  possible ruby bug?
        @return = @articles.slice!(2, 2)
      end

      it 'should return nil' do
        @return.should be_nil
      end
    end

    describe 'with a range not within the Collection' do
      before do
        # NOTE: Array#slice!(1..1) returns [], but should be nil.  possible ruby bug?
        @return = @articles.slice!(2..2)
      end

      it 'should return nil' do
        @return.should be_nil
      end
    end
  end

  it 'should respond to #sort!' do
    @articles.should respond_to(:sort!)
  end

  describe '#sort!' do
    describe 'without a block' do
      before do
        pending 'TODO: implement DataMapper::Resource#<=>' do
          @return = @other_articles.push(*@articles).sort!
        end
      end

      it 'should return a Collection' do
        @return.should be_kind_of(DataMapper::Collection)
      end

      it 'should return self' do
        @return.should be_equal(@articles)
      end

      it 'should modify and sort the Collection using default sort order' do
        @articles.should == [ @article, @other ]
      end
    end

    describe 'with a block' do
      before do
        @new_article = @model.create(:title => 'Sample Article')
        @articles << @new_article if @articles.loaded?
        @return = @articles.sort! { |a,b| b.id <=> a.id }
      end

      it 'should return a Collection' do
        @return.should be_kind_of(DataMapper::Collection)
      end

      it 'should return self' do
        @return.should be_equal(@articles)
      end

      it 'should modify and sort the Collection using supplied block' do
        @articles.should == [ @new_article, @article ]
      end
    end
  end

  it 'should respond to #unshift' do
    @articles.should respond_to(:unshift)
  end

  describe '#unshift' do
    before do
      @resources = [ @model.new(:title => 'Title 1'), @model.new(:title => 'Title 2') ]
      @return = @articles.unshift(*@resources)
    end

    it 'should return a Collection' do
      @return.should be_kind_of(DataMapper::Collection)
    end

    it 'should return self' do
      @return.should be_equal(@articles)
    end

    it 'should prepend the Resources to the Collection' do
      @articles.should == @resources + [ @article ]
    end

    it 'should relate the Resources to the Collection' do
      @resources.each { |r| r.collection.should be_equal(@articles) }
    end
  end

  it 'should respond to #update' do
    @articles.should respond_to(:update)
  end

  describe '#update' do
    before do
      pending 'TODO: implement DataMapper::Collection#update' do
        @return = @articles.update(:title => 'Updated Title')
      end
    end

    it 'should return true' do
      @return.should be_true
    end

    it 'should update attributes of all Resources' do
      @articles.each { |r| r.title.should == 'Updated Title' }
    end

    it 'should persist the changes' do
      @model.get(*@article.key).title.should == 'Updated Title'
    end
  end

  it 'should respond to #update!' do
    @articles.should respond_to(:update!)
  end

  describe '#update!' do
    describe 'with no arguments' do
      before do
        @return = @articles.update!
      end

      it 'should return true' do
        @return.should be_true
      end
    end

    describe 'with arguments' do
      before do
        @skip_class = DataMapper::Associations::ManyToMany::Proxy
        pending_if "TODO: implement #{@skip_class}#update!", @articles.kind_of?(@skip_class) && !@adapter.kind_of?(DataMapper::Adapters::InMemoryAdapter) do
          @return = @articles.update!(:title => 'Updated Title')
        end
      end

      it 'should return true' do
        @return.should be_true
      end

      it 'should bypass validation' do
        pending 'TODO: not sure how to best spec this'
      end

      it 'should update attributes of all Resources' do
        pending_if "TODO: implement #{@skip_class}#update!", @articles.kind_of?(@skip_class) do
          @articles.each { |r| r.title.should == 'Updated Title' }
        end
      end

      it 'should persist the changes' do
        pending_if "TODO: implement #{@skip_class}#update!", @articles.kind_of?(@skip_class) do
          @model.get(*@article.key).title.should == 'Updated Title'
        end
      end
    end
  end
end