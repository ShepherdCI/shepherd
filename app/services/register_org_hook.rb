class RegisterOrgHook
  include CallableService
  include HookableAction

  attribute :org, Org, default: lambda {|service,_| service.hookable }

  def call
    AddRoleUserToOrg.call(user: user, org: org)

    register_hook do |hook_secret|
      github_hook = Github::CreateOrgHook.call(
        access_token: user.token,
        org: org,
        secret: hook_secret,
        callback_url: org.webhook_url
      )

      github_hook[:id]
    end
  end
end
