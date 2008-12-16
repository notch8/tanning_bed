# $Id$

__DIR__ = File.dirname(__FILE__) + "/"

require __DIR__ + 'spec_helper.rb'

describe "TanningBed" do
  before(:each) do
    @tanning = TanningModel.new
    @burnt = BurntModel.new
  end
  
  it "should be includeable in a ruby class" do
    TanningModel.included_modules.should include(TanningBed)
  end
  
  it "should enable adding a record to solr" do
    @tanning.methods.include?("solr_add").should be_true
    @tanning.solr_add.should be_true    
  end
  
  it "should enable updating a record in solr" do
    @tanning.solr_add
    old_total = TanningBed.solr_connection.query("Big Bad Voodoo Daddy").total_hits
    @tanning.name = "Joe the Plumber"
    @tanning.solr_update
    new_total = TanningBed.solr_connection.query("Big Bad Voodoo Daddy").total_hits
    new_total.should be_eql(old_total - 1)
  end
  
  it "should enable deleting a record in solr" do
    @tanning.solr_add
    old_total = TanningBed.solr_connection.query("Big Bad Voodoo Daddy").total_hits
    @tanning.solr_delete
    new_total = TanningBed.solr_connection.query("Big Bad Voodoo Daddy").total_hits
    new_total.should be_equal(old_total - 1)
  end
  
  it "should enable searching solr for a set of search_ids" do 
    @tanning.solr_add
    @burnt.solr_add
    result = TanningBed.solr_search("Big")
    result.total_hits.should == 2
    result.hits.first["search_id"].should eql(["TanningModel 666"])
    result.hits.last["search_id"].should eql(["BurntModel 666"])
  end
  
  it "should allow searching for only records of a specific class" do
    @tanning.solr_add
    @burnt.solr_add
    result = TanningModel.solr_search("Big")
    result.total_hits.should == 1
    result.hits.first["search_id"].should eql(["TanningModel 666"])
  end
  
  it "should not add a postfix to a key that is already in the correct format" do
    ["_i", "_facet", "_t", "_f", "_d"].each do |postfix|
      @tanning.lookup_key_type("test_#{postfix}", String).should be_nil
    end
  end

end

# EOF
