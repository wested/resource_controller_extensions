module ResourceControllerExtensions
  module TransactionalUpdateAction
    def update
      load_object
      begin
        model.transaction do
          before :update
          object.update_attributes! object_params
          after :update
        end
        set_flash :update
        response_for :update
      rescue ActiveRecord::RecordInvalid
        after :update_fails
        set_flash :update_fails
        response_for :update_fails
      end
    end
  end
end