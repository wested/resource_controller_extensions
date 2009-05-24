module ResourceControllerExtensions
  module DeleteAction
    def self.included(subclass)
      subclass.class_eval do
        class_scoping_reader :delete, ResourceController::FailableActionOptions.new
        
        delete.wants.html do
          if template_exists?
            render
          else
            render :template => 'defaults/delete'
          end
        end
        
      end
    end
    
    def delete
      load_object
      before :delete
      response_for :delete
    end
  end
end