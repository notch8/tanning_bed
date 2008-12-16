require 'rubygems'
require 'rake'
require 'net/http'
require 'fileutils'

namespace :solr do

  desc 'Starts Solr. PORT=XX.'
  task :start do
    begin
      n = Net::HTTP.new('localhost', solr_port)
      n.request_head('/').value 

    rescue Net::HTTPServerException #responding
      puts "Port #{solr_port} in use" and return

    rescue Errno::ECONNREFUSED #not responding
      Dir.chdir(solr_path) do
        pid = fork do
          #STDERR.close
          exec "java -Dsolr.data.dir=solr/data -Djetty.port=#{solr_port} -jar start.jar"
        end
        sleep(5)
        FileUtils.mkdir_p("#{solr_path}/tmp")
        File.open("#{solr_path}/tmp/solr_pid", "w"){ |f| f << pid}
        puts "Solr started successfully on #{solr_port}, pid: #{pid}."
      end
    end
  end
  
  desc 'Stops Solr.'
  task :stop do
    fork do
      file_path = "#{solr_path}/tmp/solr_pid"
      if File.exists?(file_path)
        File.open(file_path, "r") do |f| 
          pid = f.readline
          Process.kill('TERM', pid.to_i)
        end
        File.unlink(file_path)
        # Rake::Task["solr:destroy_index"].invoke if ENV['RAILS_ENV'] == 'test'
        puts "Solr shutdown successfully."
      else
        puts "Solr is not running.  I haven't done anything."
      end
    end
  end
  
  desc 'Remove Solr index'
  task :destroy_index do
    if File.exists?("#{solr_path}/solr/data")
      Dir[ solr_path + "/solr/data/index/*"].each{|f| File.unlink(f)}
      Dir.rmdir(solr_path + "/solr/data/index")
      puts "Index files removed under #{sorl_path}/solr/data/index" 
    end
  end
  
  def solr_port
    if defined?(SOLR_PORT)
      return SOLR_PORT
    else
      return "8983"
    end
  end
  
  def solr_path
    if defined?(SOLR_PATH)
      return SOLR_PATH
    else
      return "#{File.dirname(__FILE__)}/../vendor/solr"
    end
  end
end
