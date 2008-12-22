# $Id$
require 'open-uri'
__DIR__ = File.dirname(__FILE__) + "/"

require __DIR__ + 'spec_helper.rb'

describe "TanningBed" do
  before(:all) do
    begin
      open("http://localhost:8984/solr")
    rescue
      puts "Solr must be started on port 8984 before you run the specs.  Use rake solr:start SOLR_PORT=8984"
      exit 1
    end
    TanningBed.solr_connection('http://localhost:8984/solr', :on)
  end
    
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
  
  it "should swallow exceptions by default if Solr is down" do
    tmp_file = __DIR__ + "/tmp/solr_err.tmp"
    FileUtils.mkdir_p(__DIR__ + "/tmp")
    TanningBed.solr_connection('http://localhost:9999/solr', :on, true)

    old_err = $stderr
    $stderr = File.open(tmp_file, "w")
    TanningBed.solr_search("test")
    $stderr.flush
    $stderr.close
    $stderr = old_err
    File.open(tmp_file, "r") do |file|
      file.read.should == "SOLR - Connection refused - connect(2)\n"
    end
    TanningBed.solr_connection('http://localhost:8984/solr', :on, true)
    
  end
  
  it "should store a proc to handle exceptions if Solr is down" do
    tmp_file = __DIR__ + "/tmp/solr_err.tmp"

    TanningBed.solr_connection('http://localhost:9999/solr', :on, true)
    
    TanningBed.on_solr_exception = Proc.new {|e| raise e}
    lambda {TanningBed.solr_search("test")}.should raise_error(Errno::ECONNREFUSED)

    TanningBed.on_solr_exception = nil
    TanningBed.solr_connection('http://localhost:8984/solr', :on, true)    
  end
  

end

# EOF
