class DeregisterOrgHook
  include CallableService
  include HookableAction

  attribute :org, Org, default: lambda {|service,_| service.hookable }

  def call
    deregister_hook do |hook_id|
      Github::DeleteOrgHook.call(
        access_token: user.token,
        org: org,
        github_webhook_id: hook_id
      )
    end
  end
end
