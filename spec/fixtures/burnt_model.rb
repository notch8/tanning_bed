class BurntModel
  include TanningBed
  attr_accessor :name, :description

  def initialize
    @name = "Big Bad Voodoo Daddy"
    @description = "Not really that bad after all."
  end
  
  def id
    666
  end
  
  def find(value)
    666
  end
  alias :get :find

  def solr_keys
    ["name", "description"]
  end
end