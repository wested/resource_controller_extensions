require File.dirname(__FILE__) + '/../test_helper'

ActionController::Routing::Routes.draw do |map|
  map.resources :projects, :member => {:delete => :get}
end

class ProjectsController < ActionController::Base
  resource_controller
  add_extensions :delete
end

class DeleteActionExtensionsTest < ActionController::TestCase
  tests ProjectsController
  
  context "A controller with the :delete extension added" do
    
    setup do
      # don't look for views...
      @controller.stubs(:render)
    end
    
    should "have a delete action" do
      assert ProjectsController.new.respond_to?(:delete)
    end
    
    context "delete action" do
      setup do
        Project.create(:name => 'Test')
      end
      
      should "assign_to :project" do
        get :delete, :id => 1
        assert_not_nil assigns(:project)
      end
      
      should "call find on project with the provided id" do
        Project.expects(:find).with('1')
        get :delete, :id => 1
      end
    end
    
    context "with a delete.before block" do
      ProjectsController.instance_eval do 
        delete.before do
          @user_id = 1
        end
      end
      
      should "assign_to :user" do
        Project.stubs(:find).returns(:foo)
        
        get :delete, :id => 1
        assert_not_nil assigns(:user_id)
      end
    end
  end
end