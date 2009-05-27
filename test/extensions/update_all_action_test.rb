require File.dirname(__FILE__) + '/../test_helper'

ActionController::Routing::Routes.draw do |map|
  map.resources :projects, :collection => {:update_all => :put}, :controller => 'update_all_action_extensions_test/projects'
end

class UpdateAllActionExtensionsTest < ActionController::TestCase
  class ProjectsController < ActionController::Base
    resource_controller
    add_extensions :update_all
    
    def update_all_action_extensions_test_projects_url
      projects_url
    end
  end
  tests ProjectsController
  
  context "A controller with the :update_all extension added" do
    should "have a update_all action" do
      assert ProjectsController.new.respond_to?(:update_all)
    end
    
    context "successful update_all action" do
      setup do
        Project.create(:name => 'First', :position => 1)
        Project.create(:name => 'Second', :position => 2)
        
        put :update_all, :projects => [{:id => 1, :position => 2}, {:id => 2, :position => 1}]
      end
      
      should "update the records as appropriate" do
        assert(2,Project.find(1).position)
        assert(1,Project.find(2).position)
      end
      
      should_redirect_to "the collection url" do
        projects_url
      end
      
      should_set_the_flash_to "All successfully updated!"
      should_assign_to :collection
      should_assign_to :projects
    end
    
    context "failed update_all action" do
    end
    
  end
end