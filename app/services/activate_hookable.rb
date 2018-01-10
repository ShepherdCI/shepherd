class ActivateHookable
  include CallableService
  include Virtus.model

  attribute :user, User
  attribute :hookable, Hookable
  attribute :activator, Object, default: (lambda {|service, _| service.hookable.hook_registration_service })

  def call
    activator.call(user: user, hookable: hookable)
  end
end
