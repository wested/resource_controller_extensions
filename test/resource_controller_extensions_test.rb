require File.dirname(__FILE__) + '/test_helper'

class ResourceControllerExtensionsTest < Test::Unit::TestCase
  context "A controller that has called resource_controller" do
    setup do
      class ApplicationController < ActionController::Base
      end

      class HomeController < ApplicationController
      end

      class UsersController < ApplicationController
        resource_controller
      end
      @controller_class = UsersController
    end
    
    should "have class method add_extensions" do
      assert @controller_class.respond_to?(:add_extensions)
    end
    
    
    context "when add_extension is called with :delete_action" do
      should "include the DeleteAction" do
        @controller_class.instance_eval do
          add_extensions :delete
        end
        assert_includes @controller_class.included_modules, ResourceControllerExtensions::DeleteAction
      end
    end
    
    context "when add_extension is called with :searchlogic_collection" do
      should "include SearchlogicCollection" do
        @controller_class.instance_eval do
          add_extensions :searchlogic
        end
        assert_includes @controller_class.included_modules, ResourceControllerExtensions::SearchlogicCollection
      end
    end
    
    context "when add_extension is called with :all" do
      should "include DeleteAction and SearchlogicCollection" do
        @controller_class.instance_eval do
          add_extensions :all
        end
        assert_includes @controller_class.included_modules, ResourceControllerExtensions::DeleteAction
        assert_includes @controller_class.included_modules, ResourceControllerExtensions::ImprovedErrorHandling
        assert_includes @controller_class.included_modules, ResourceControllerExtensions::IndexPreload
        assert_includes @controller_class.included_modules, ResourceControllerExtensions::SearchlogicCollection
      end
    end
    
    context "when add_extension is called with :foobar" do
      should_raise(ArgumentError) do
        @controller_class.instance_eval do
          add_extensions :foobar
        end
      end
    end
    
  end
  
  context "A controller that has not called resource_controller" do
    setup do
      @controller_class = HomeController
    end
    
    should "not have class method add_extensions" do
      assert ! @controller_class.respond_to?(:add_extensions)
    end
  end
end
