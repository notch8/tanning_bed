class TanningModel
  include TanningBed
  attr_accessor :name, :description, :tan_facet
  def initialize
    @name        = "Big Bad Voodoo Daddy"
    @description = "Not really that bad after all."
    @tan_facet   =     "dark"
  end
  
  def id
    666
  end
  
  
  def solr_keys
    ["name", "description", "tan_facet"]
  end
end