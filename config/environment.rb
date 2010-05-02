RAILS_ROOT = "#{File.dirname(__FILE__)}/.." unless defined?(RAILS_ROOT)
ENV["mode"] ||= "development"
ENV["logger"] ||= "quiet"

require "rubygems"
require "active_record"
require "active_support"
require "mysql"
require 'yaml'

if ENV["logger"]=="loud"
  ActiveRecord::Base.logger = Logger.new(STDERR)
else
  logfile = File.open("#{RAILS_ROOT}/logs/development.log","w")
  ActiveRecord::Base.logger = Logger.new(logfile)
end

ActiveRecord::Base.colorize_logging = true

dbconfig = YAML.load_file('config/database.yml')
ActiveRecord::Base.establish_connection(dbconfig[ENV["mode"]])

Dir["models/*.rb"].each {|file| require file }
