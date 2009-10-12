ENV["mode"] = "test"

require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'active_support'
require 'active_support/test_case'
require 'action_controller'
require 'test_help'

class ActiveSupport::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
end

