module ResourceControllerExtensions
  module ActionControllerExtension
    module ClassMethods
      def resource_controller_with_extendability(*args)
        resource_controller_without_extendability
        extend ResourceControllerExtensions::ClassMethods
      end
    end
    
    def self.included(base)
      base.class_eval do
        extend ClassMethods
        
        # modifying the class object as we're aliasing a class method
        class << self 
          alias_method_chain :resource_controller, :extendability
        end
      end
    end
    
    protected
    def template_exists?(template_name = default_template_name)
      self.view_paths.find_template(template_name, response.template.template_format)
    rescue ActionView::MissingTemplate
      false
    end
  end
  
  module ClassMethods
    EXTENSIONS = {
      :delete                  => ResourceControllerExtensions::DeleteAction,
      :searchlogic             => ResourceControllerExtensions::SearchlogicCollection,
      :index_preload           => ResourceControllerExtensions::IndexPreload,
      :improved_error_handling => ResourceControllerExtensions::ImprovedErrorHandling
    }
    
    def add_extensions(*extensions)
      if extensions.include?(:all)
        EXTENSIONS.values.each do |extension|
          include extension
        end
      else
        extensions.each do |extension_name|
          if EXTENSIONS[extension_name]
            include EXTENSIONS[extension_name]
          else
            raise ArgumentError, "'#{extension_name}' is not a known extension"
          end
        end
      end
    end
  end
end
