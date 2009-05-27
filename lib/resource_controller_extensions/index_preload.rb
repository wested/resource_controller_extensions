module ResourceControllerExtensions
  module IndexPreload

    def self.included(subclass)
      subclass.class_eval do
        index.instance_eval do
          class << self
            reader_writer :preload
          end
        end
        
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
