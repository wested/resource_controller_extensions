module ResourceControllerExtensions
  module IndexPreload
    class CollectionActionOptions < ResourceController::ActionOptions
      reader_writer :preload
    end
    
    def self.included(subclass)
      subclass.class_eval do
        class_scoping_reader :index, CollectionActionOptions.new
        index.wants.html
        
        alias_method_chain :end_of_association_chain, :preloading
      end
    end
    
    def end_of_association_chain_with_preloading
      preload = options_for(:index).preload
      
      if preload.class == Proc
        preload = preload.call
      end
      
      if preload
        end_of_association_chain_without_preloading.scoped(:include => preload)
      else
        end_of_association_chain_without_preloading
      end
    end
    
  end
end
