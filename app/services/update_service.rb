class UpdateService
  include CallableService
  include Virtus.model

  attribute :user, User
  attribute :service, Service
  attribute :params, Hash

  def call
    service.update_attributes(params)

    hookable = service.hookable

    if hookable.services.any?(&:active?)
      unless hookable.active?
        HookableActivationJob.perform_later(hookable, user)
      end
    else
      if hookable.active?
        HookableDeactivationJob.perform_later(hookable, user)
      end
    end

    service
  end
end
