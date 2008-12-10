__DIR__ = File.dirname(__FILE__) + "/"
require __DIR__ + '../vendor/solr-ruby/lib/solr.rb'

module TanningBed
  module ClassMethods
    def solr_search(query_string)
      TanningBed.solr_connection.query(query_string + " AND type_t:#{self}")
    end
  end
  
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  # connect to the solr instance
  def self.solr_connection
    @@conn ||= Solr::Connection.new('http://localhost:8983/solr', :autocommit => :on)
  end
  
  def solr_id
    "#{self.class} #{self.id}"
  end

  # add a document to the index
  def solr_add
    TanningBed.solr_connection.add(search_fields)
  end

  def solr_update
    TanningBed.solr_connection.update(search_fields)
  end

  def self.solr_search(query_string)
    TanningBed.solr_connection.query(query_string)
  end

  def solr_delete
    TanningBed.solr_connection.delete(solr_id)
  end

  def solr_keys
    raise "You must define the method solr_keys in the class you want to use for Solr.\n  This should return an array of method names to call on you're class for indexing\n eg: ['id', 'name', 'description']"
  end
  
  def search_fields
    fields = {}
    self.solr_keys.each do |key|
      if self.respond_to?(key)
        value = self.send(key)
        key_type = lookup_key_type(key, value.class)        
        fields["#{key}#{key_type}"] = value
      end
    end
    fields[:search_id] = solr_id
    fields[:type_t] = self.class.to_s
    fields[:id_t] = self.id
    return fields
  end

  def lookup_key_type(key, klass)
    # is the key already in the correct_format?
    key_postfix = key.split("_").last
    return nil if ["i", "facet", "t", "f", "d"].include?(key_postfix)
    
    # Add the helper to the key string
    case klass.to_s
    when "Fixnum"
      "_i"
    when "String"
      if key.size < 255
        "_facet"
      else
        "_t"
      end
    when "Float"
      "_f"
    when "Date", "Datetime", "Time"
      "_d"
    else
      "_t"
    end
  end
  
end