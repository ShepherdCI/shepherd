class MigrateRegisteredHookEndpoint
  include CallableService

  attribute :hook, RegisteredHook
  attribute :user, User

  def call
    hookable = hook.hookable

    if hookable.github_webhook_id
      raise "Cannot migrate #{self.inspect}. Hook already exists on parent"
    end

    if hookable.repo?
      Github::UpdateRepoHook.call(
        id: hook.github_id,
        secret: hook.secret,
        repo: hookable,
        callback_url: hookable.webhook_url,
        access_token: user.token,
      )
    elsif hookable.org?
      Github::UpdateOrgHook.call(
        id: hook.github_id,
        secret: hook.secret,
        org: hookable,
        callback_url: hookable.webhook_url,
        access_token: user.token,
      )
    end

    hookable.update_attributes!(
      github_webhook_id: hook.github_id,
      github_webhook_secret: hook.secret,
    )

    hook.update_attributes!(
      migrated_to_hookable: true
    )
  end
end
