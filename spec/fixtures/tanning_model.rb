class TanningModel
  include TanningBed
  attr_accessor :name, :description, :tan_facet, :keywords
  def initialize
    @name        = "Big Bad Voodoo Daddy"
    @description = "Not really that bad after all."
    @tan_facet   = "dark"
    @keywords = ["Record", "stuff", "other"]
  end
  
  def id
    666
  end

  def keywords_facet
    keywords
  end
  
  
  def solr_keys
    ["name", "description", "tan_facet", "keywords_facet"]
  end
end
