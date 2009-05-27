require File.dirname(__FILE__) + '/../test_helper'

ActionController::Routing::Routes.draw do |map|
  map.resources :projects
end

class ProjectsController < ActionController::Base
  resource_controller
  add_extensions :improved_error_handling
end

class ImprovedErrorHandlingTest < ActionController::TestCase
  tests ProjectsController
  
  setup do
    class ProjectsController
      def rescue_action(exception)
        raise exception
      end
    end
  end
  
  should_raise(ActiveRecord::RecordNotFound) do
    get :show, :id => 1
  end
end