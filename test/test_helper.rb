require 'rubygems'

require 'activerecord'
require 'action_controller'

require 'test/unit'

require 'shoulda'
require 'shoulda/action_controller'
require 'woulda'


root = File.join(File.dirname(__FILE__), '..')
require File.join(root, 'test/models.rb')

ActiveSupport::Dependencies.load_paths << File.join(root, '..', 'searchlogic', 'lib')
Searchlogic

ActiveSupport::Dependencies.load_paths << File.join(root, '..', 'resource_controller', 'lib')
require File.join(root, '..', 'resource_controller', 'init.rb')

ActiveSupport::Dependencies.load_paths << File.join(root, 'lib')
require File.join(root, 'init.rb')

def assert_includes(array, obj, message = nil)
  full_message = build_message(message, "expected <?> to include <?>", array, obj)
  assert_block(full_message) { array.include?(obj) }
end
