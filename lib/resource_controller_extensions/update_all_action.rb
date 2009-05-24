module ResourceControllerExtensions
  module UpdateAllAction
    def self.included(subclass)
      subclass.class_eval do
        class_scoping_reader :update_all, ResourceController::FailableActionOptions.new
        
        update_all do
          flash "All successfully updated!"
          wants.html do
            redirect_to collection_url
          end
        end
      end
    end
    
    def update_all
      before :update_all
      
      objects_params = params["#{object_name.pluralize}"]
      
      begin
        model.transaction do
          objects_params.each do |attributes|
            id = attributes.delete("id")
            model.find(id).update_attributes!(attributes)
          end
          after :update_all
        end
        set_flash :update_all
        response_for :update_all
      rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotFound
        after :update_all_fails
        set_flash :update_all_fails
        response_for :update_all_fails
      end
    end
    
    private
    
    # overriding buggy regexp in existing options_for()...
    def options_for(action)
      action = action == :new_action ? [action] : "#{action}".split(/_(?=fails)/).map(&:to_sym)
      options = self.class.send(action.first)
      options = options.send(action.last == :fails ? :fails : :success) if ResourceController::FAILABLE_ACTIONS.include? action.first

      options
    end
      
  end
end