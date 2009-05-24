require File.dirname(__FILE__) + '/../test_helper'

ActionController::Routing::Routes.draw do |map|
  map.resources :projects, :collection => {:search => :get}
end

class ProjectsController < ActionController::Base
  resource_controller
  add_extensions :searchlogic
end

class SearchlogicCollectionTest < ActionController::TestCase
  tests ProjectsController
  setup do
    # don't look for views...
    @controller.stubs(:render)
  end
  
  context "search_object method" do
    should "return a searchlogic object" do
      assert_kind_of(Searchlogic::Search::Base, @controller.send(:search_object))
    end
  end
  
  context "collection method" do
    should "call :all on search_object and return it" do
      @controller.send(:search_object).expects(:all).returns(:foo)
      assert_equal(:foo, @controller.send(:collection))
    end
  end
  
  context "search action" do
    setup do
      @controller.stubs(:render)
      get :search
    end
    
    should "assign a searchlogic object to @search" do
      assert_kind_of(Searchlogic::Search::Base, assigns(:search))
    end
    
    should "accept a search.before block" do
      ProjectsController.instance_eval do 
        search.before do
          @user_id = 1
        end
      end
      
      get :search
      assert_not_nil assigns(:user_id)
    end
  end
end
