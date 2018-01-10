module HookableAction
  include Virtus.module

  attribute :user, User
  attribute :hookable, Hookable

  def register_hook(&block)
    ApplicationRecord.transaction do
      hook_id = yield hookable.github_webhook_secret

      hookable.update_attributes(github_webhook_id: hook_id)
      hookable.activate
    end
  end

  def deregister_hook(&block)
    ApplicationRecord.transaction do
      if hookable.github_webhook_id.present?
        status = yield hookable.github_webhook_id

        if status.success?
          hookable.update_attributes(github_webhook_id: nil)
          hookable.deactivate
        else
          raise status.message
        end
      else
        hookable.deactivate
      end
    end
  end
end
