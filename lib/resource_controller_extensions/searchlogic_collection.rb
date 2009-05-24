module ResourceControllerExtensions
  module SearchlogicCollection
    class CollectionActionOptions < ResourceController::ActionOptions
      block_accessor :preload
    end
    
    def self.included(subclass)
      subclass.class_eval do
        class_scoping_reader :search, ResourceController::ActionOptions.new
        class_scoping_reader :index, CollectionActionOptions.new
        
        search.wants.html do
          render
        end
        
      end
    end
    
    def search
      before :search
      load_search_object
      response_for :search
    end
    
    protected
    
    def collection
      @collection ||= search_object.all
    end
    
    def search_object
      @search_object ||= end_of_association_chain.new_search(params[:search])
    end
    
    def load_search_object
      @search = search_object
    end
  end
end