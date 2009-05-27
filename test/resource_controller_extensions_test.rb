require File.dirname(__FILE__) + '/test_helper'

class ResourceControllerExtensionsTest < ActionController::TestCase
  class HomeController < ActionController::Base
  end

  class ProjectsController < ActionController::Base
    resource_controller
  end
  
  tests ProjectsController
  context "A controller that has called resource_controller" do
    should "have class method add_extensions" do
      assert ProjectsController.respond_to?(:add_extensions)
    end
    
    
    context "when add_extension is called with :delete_action" do
      should "include the DeleteAction" do
        ProjectsController.instance_eval do
          add_extensions :delete
        end
        assert_includes ProjectsController.included_modules, ResourceControllerExtensions::DeleteAction
      end
    end
    
    context "when add_extension is called with :searchlogic_collection" do
      should "include SearchlogicCollection" do
        ProjectsController.instance_eval do
          add_extensions :searchlogic
        end
        assert_includes ProjectsController.included_modules, ResourceControllerExtensions::SearchlogicCollection
      end
    end
    
    context "when add_extension is called with :all" do
      should "include DeleteAction and SearchlogicCollection" do
        ProjectsController.instance_eval do
          add_extensions :all
        end
        
        [
          ResourceControllerExtensions::DeleteAction,
          ResourceControllerExtensions::ImprovedErrorHandling,
          ResourceControllerExtensions::IndexPreload,
          ResourceControllerExtensions::SearchlogicCollection,
          ResourceControllerExtensions::TransactionalUpdateAction,
          ResourceControllerExtensions::UpdateAllAction
        ].each do |mod|
          assert_includes ProjectsController.included_modules, mod
        end
      end
    end
    
    context "when add_extension is called with :foobar" do
      should_raise(ArgumentError) do
        ProjectsController.instance_eval do
          add_extensions :foobar
        end
      end
    end
    
  end
  
  context "a controller calling add_extension twice" do
    should "include both extensions" do
      ProjectsController.instance_eval do
        add_extensions :delete
        add_extensions :searchlogic
      end
      
      assert_includes ProjectsController.included_modules, ResourceControllerExtensions::DeleteAction
      assert_includes ProjectsController.included_modules, ResourceControllerExtensions::SearchlogicCollection
    end
  end
  
  context "A controller that has not called resource_controller" do
    should "not have class method add_extensions" do
      assert ! HomeController.respond_to?(:add_extensions)
    end
  end
end
