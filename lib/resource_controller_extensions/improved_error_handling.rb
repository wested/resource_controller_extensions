module ResourceControllerExtensions
  module ImprovedErrorHandling
    def self.included(subclass)
      subclass.class_eval do
        show.fails.wants.html do
          raise ActiveRecord::RecordNotFound
        end
      end
    end
  end
end