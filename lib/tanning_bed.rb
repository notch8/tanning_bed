__DIR__ = File.dirname(__FILE__) + "/"
$: << File.expand_path(__DIR__ + '../vendor/solr-ruby/lib')
require 'solr'

# $Id$

# Equivalent to a header guard in C/C++
# Used to prevent the class/module from being loaded more than once
unless defined? TanningBed

module TanningBed
  module ClassMethods
    def solr_search(query_string, options={})
      TanningBed.solr_connection.query(query_string + " AND type_t:#{self}", options)
    rescue Errno::ECONNREFUSED => e
      TanningBed.solr_exception(e)      
    end
    
    def solr_load(results)
      key_set = results.collect do |result|
        key = result["search_id"].first.split(" ")
        next if key[0] != self.to_s
        Kernel.const_get(key[0]).send(:get, key[1])
      end
      key_set.delete(nil)
      return key_set
    end
    
    def solr_reindex
      # Remove all the old entries for this class
      TanningBed.solr_connection.delete_by_query(self.to_s)
      
      #Add all the current records into the index
      self.all.each do |item|
        item.solr_add
      end
    end
  end
  
  def self.included(base)
    @@conn = nil
    @@on_solr_exception = nil
    base.extend(ClassMethods)
  end
  
  # connect to the solr instance
  def self.solr_connection(url='http://localhost:8983/solr', autocommit=:on, reset=false)
    if reset
      @@conn = Solr::Connection.new(url, :autocommit => autocommit) 
    else
      @@conn ||= Solr::Connection.new(url, :autocommit => autocommit)
    end
  end  
  
  def self.solr_exception(e)
    if TanningBed.on_solr_exception
      TanningBed.on_solr_exception.call(e)
    else
      $stderr.puts("SOLR - " + e)
    end
  end
  
  def self.on_solr_exception
    @@on_solr_exception
  end
  
  def self.on_solr_exception=(value)
    @@on_solr_exception = value
  end
  
  def solr_id
    "#{self.class} #{self.id}"
  end

  # add a document to the index
  def solr_add
    TanningBed.solr_connection.add(search_fields)
  rescue Errno::ECONNREFUSED => e
    TanningBed.solr_exception(e)
  end

  def solr_update
    TanningBed.solr_connection.update(search_fields)
  rescue Errno::ECONNREFUSED => e
    TanningBed.solr_exception(e)
  end

  def self.solr_search(query_string, options={})
    TanningBed.solr_connection.query(query_string, options)
  rescue Errno::ECONNREFUSED => e
    TanningBed.solr_exception(e)
  end
  
  def self.solr_load(results)
    key_set = results.collect do |result|
      key = result["search_id"].first.split(" ")
      Kernel.const_get(key[0]).send(:get, key[1])
    end
    return key_set
  end

  def solr_delete
    TanningBed.solr_connection.delete(solr_id)
  rescue Errno::ECONNREFUSED => e
    TanningBed.solr_exception(e)
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
    return nil if ["i", "facet", "t", "f", "d", "mv"].include?(key_postfix)
    
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
    when "Array"
      "_s_mv"
    else
      "_t"
    end
  end


  # :stopdoc:
  VERSION = '0.0.8'
  LIBPATH = ::File.expand_path(::File.dirname(__FILE__)) + ::File::SEPARATOR
  PATH = ::File.dirname(LIBPATH) + ::File::SEPARATOR
  # :startdoc:

  # Returns the version string for the library.
  #
  def self.version
    VERSION
  end

  # Returns the library path for the module. If any arguments are given,
  # they will be joined to the end of the libray path using
  # <tt>File.join</tt>.
  #
  def self.libpath( *args )
    args.empty? ? LIBPATH : ::File.join(LIBPATH, *args)
  end

  # Returns the lpath for the module. If any arguments are given,
  # they will be joined to the end of the path using
  # <tt>File.join</tt>.
  #
  def self.path( *args )
    args.empty? ? PATH : ::File.join(PATH, *args)
  end

  # Utility method used to rquire all files ending in .rb that lie in the
  # directory below this file that has the same name as the filename passed
  # in. Optionally, a specific _directory_ name can be passed in such that
  # the _filename_ does not have to be equivalent to the directory.
  #
  def self.require_all_libs_relative_to( fname, dir = nil )
    dir ||= ::File.basename(fname, '.*')
    search_me = ::File.expand_path(
        ::File.join(::File.dirname(fname), dir, '**', '*.rb'))

    Dir.glob(search_me).sort.each {|rb| require rb}
  end

end  # module TanningBed

TanningBed.require_all_libs_relative_to __FILE__

end  # unless defined?

# EOF
