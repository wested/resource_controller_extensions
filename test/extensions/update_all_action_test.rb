require File.dirname(__FILE__) + '/../test_helper'

ActionController::Routing::Routes.draw do |map|
  map.resources :projects, :controller => 'update_all_action_extensions_test/projects' do |project|
    project.resources :tasks, :controller => 'update_all_action_extensions_test/tasks', :collection => {:update_all => :put}
  end 
end

class UpdateAllActionExtensionsTest < ActionController::TestCase
  class ProjectsController < ActionController::Base
    resource_controller
    add_extensions :update_all
  end
  
  class TasksController < ActionController::Base
    resource_controller
    add_extensions :update_all
    belongs_to :project
    
    def update_all_action_extensions_test_project_tasks_url(*args)
      projects_url
    end
  end
  
  
  tests TasksController
  
  context "A controller with the :update_all extension added" do
    should "have a update_all action" do
      assert TasksController.new.respond_to?(:update_all)
    end
    
    context "successful update_all action" do
      setup do
        @project = Project.create!(:name => 'First')
        @task_1 = @project.tasks.create!(:name => 'A', :complete => false)
        @task_2 = @project.tasks.create!(:name => 'B', :complete => false)
        put :update_all, :project_id => @project.id, :tasks => [{:id => @task_1.id, :complete => true}, {:id => @task_2.id, :complete => true}]
      end
      
      should "update the records as appropriate" do
        assert(true,Task.find(@task_1).complete)
        assert(true,Task.find(@task_2).complete)
      end
      
      should_redirect_to "the collection url" do
        projects_url
      end
      
      should_set_the_flash_to "All successfully updated!"
      should_assign_to :project
      should_assign_to :collection
      should_assign_to :tasks
    end
    
    context "failed update_all action" do
    end
  end
  
end