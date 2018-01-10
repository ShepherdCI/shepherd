module CallableService
  extend ActiveSupport::Concern

  included do
    include Virtus.model

    def self.call(*args)
      instance = new(*args)

      if instance.respond_to? :around_call
        instance.around_call
      else
        instance.call
      end
    end
  end
end
