__DIR__ = File.dirname(__FILE__) + "/"

require __DIR__ + 'spec_helper.rb'

describe "TanningBed" do
  before(:each) do
    @example = TanningModel.new
  end
  
  it "should be includeable in a ruby class" do
    TanningModel.included_modules.should include(TanningBed)
  end
  
  it "should enable adding a record to solr" do
    @example.methods.include?("solr_add").should be_true
    @example.solr_add.should be_true    
  end
  
  it "should enable updating a record in solr" do
    @example.solr_add
    old_total = TanningBed.solr_connection.query("Big Bad Voodoo Daddy").total_hits
    @example.name = "Joe the Plumber"
    @example.solr_update
    new_total = TanningBed.solr_connection.query("Big Bad Voodoo Daddy").total_hits
    new_total.should be_eql(old_total - 1)
  end
  
  it "should enable deleting a record in solr" do
    pending
  end
  
  it "should enable searching solr for a set of records (by ids)" do 
    @example.solr_add
    result = TanningBed.solr_search("Big")
    result.total_hits.should == 1
    puts result.inspect
  end
  
  it "should allow searching for only records of a specific class" do
    pending
  end

end
