require 'rubygems'

require 'activerecord'
require 'action_controller'

require 'test/unit'

require 'shoulda'
require 'shoulda/action_controller'
require 'woulda'

require 'models'

ROOT                     = File.join(File.dirname(__FILE__), '..')

# ActiveSupport::Dependencies.load_paths << File.join(RESOURCE_CONTROLLER_ROOT, 'lib', 'resource_controller')

["resource_controller", "searchlogic"].each do |plugin|
  ActiveSupport::Dependencies.load_paths << File.join(ROOT, '..', plugin, 'lib')
  require File.join(ROOT, '..', plugin, 'init.rb')
end

ActiveSupport::Dependencies.load_paths << File.join(ROOT, 'lib')
require File.join(ROOT, 'init.rb')

def assert_includes(array, obj, message = nil)
  full_message = build_message(message, "expected <?> to include <?>", array, obj)
  assert_block(full_message) { array.include?(obj) }
end
