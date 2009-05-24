require File.dirname(__FILE__) + '/../test_helper'

ActionController::Routing::Routes.draw do |map|
  map.resources :projects
end

class ProjectsController < ActionController::Base
  resource_controller
  add_extensions :index_preload
end

class IndexPreloadTest < ActionController::TestCase
  tests ProjectsController
  should "include additional item in the collection using index.preload option" do
    ProjectsController.instance_eval do 
      index.preload :tasks
    end
    assert_equal({:include => :tasks}, @controller.send(:end_of_association_chain).proxy_options)
  end
end