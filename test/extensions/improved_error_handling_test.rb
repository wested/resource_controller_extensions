require File.dirname(__FILE__) + '/../test_helper'

ActionController::Routing::Routes.draw do |map|
  map.resources :projects, :controller => 'improved_error_handling_test/projects'
end

class ImprovedErrorHandlingTest < ActionController::TestCase
  class ProjectsController < ActionController::Base
    resource_controller
    add_extensions :improved_error_handling
  end
  
  tests ProjectsController
  
  setup do
    # reraise exception of one is thrown...
    class ProjectsController
      def rescue_action(exception)
        raise exception
      end
    end
  end
  
  should_raise(ActiveRecord::RecordNotFound) do
    get :show, :id => 42
  end
end