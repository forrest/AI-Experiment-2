# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'environment.rb'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'tasks/rails'


desc "Drop then recreate the dev database, migrate up, and load fixtures"
task :remigrate => :environment do
  ActiveRecord::Base.connection.tables.each { |t| ActiveRecord::Base.connection.drop_table t }
  Rake::Task['db:migrate'].invoke
end
