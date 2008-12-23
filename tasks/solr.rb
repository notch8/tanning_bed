require 'rubygems'
require 'rake'
require 'net/http'
require 'fileutils'

namespace :solr do
  
  desc 'Start Solr for tests.  Sets SOLR_PORT to 8984 and index is puts in /tmp'
  task :start_testing do
    ENV["SOLR_PORT"] = '8984'
    solr_command = "java -Dsolr.data.dir=/tmp -Djetty.port=#{solr_port} -jar start.jar"
    start_solr(solr_command)
  end

  desc 'Starts Solr. SOLR_PORT=XX. SOLR_PATH=yy'
  task :start do
    solr_command = "java -Dsolr.data.dir=solr/data -Djetty.port=#{solr_port} -jar start.jar"
    start_solr(solr_command)
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
    index_path = "#{solr_path}/solr/data"
    if File.exists?(index_path)
      Dir[ index_path + "/index/*"].each{|f| File.unlink(f)}
      Dir.rmdir(index_path + "/index")
      puts "Index files removed under #{index_path}/index" 
    end
  end
  
  def solr_port
    if ENV["SOLR_PORT"]
      return ENV["SOLR_PORT"]
    else
      return "8983"
    end
  end
  
  def solr_path
    if ENV["SOLR_PATH"]
      return ENV["SOLR_PATH"]
    else
      return "#{File.dirname(__FILE__)}/../vendor/solr"
    end
  end
  
  def start_solr(solr_command)
    begin
      n = Net::HTTP.new('localhost', solr_port)
      n.request_head('/').value 

    rescue Net::HTTPServerException #responding
      puts "Port #{solr_port} in use" and return

    rescue Errno::ECONNREFUSED #not responding
      Dir.chdir(solr_path) do
        pid = fork do
          #STDERR.close
          exec solr_command
        end
        sleep(5)
        FileUtils.mkdir_p("#{solr_path}/tmp")
        File.open("#{solr_path}/tmp/solr_pid", "w"){ |f| f << pid}
        puts "Solr started successfully on #{solr_port}, pid: #{pid}."
      end
    end
  end
end
