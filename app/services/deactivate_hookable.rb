class DeactivateHookable
  include CallableService
  include Virtus.model

  attribute :user, User
  attribute :hookable, Hookable
  attribute :deactivator, Object, default: (lambda {|service, _| service.hookable.hook_deregistration_service })

  def call
    deactivator.call(user: user, hookable: hookable)
  end
end
