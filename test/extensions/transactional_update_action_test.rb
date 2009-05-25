require File.dirname(__FILE__) + '/../test_helper'

ActionController::Routing::Routes.draw do |map|
  map.resources :projects
end

class ProjectsController < ActionController::Base
  resource_controller
  add_extensions :transactional_update
end

class TransactionalUpdateActionExtensionsTest < ActionController::TestCase
  tests ProjectsController
  
  context "A controller with the :transactional_actions extension added" do
    setup do
      @controller.stubs(:render)
    end
    
    should "wrap the update action in a transaction" do
      c = Category.create!(:name => 'Foo')
      p = Project.create!(:name => 'Test')
      
      put :update, :id => p.id, :project => {:name => '', :category_ids => [c.id]}
      
      p.reload
      assert_equal [], p.category_ids
    end
  end
end