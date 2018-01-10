class DeregisterRepoHook
  include CallableService
  include HookableAction

  attribute :repo, Repo, default: lambda {|service,_| service.hookable }

  def call
    deregister_hook do |hook_id|
      Github::DeleteRepoHook.call(
        access_token: user.token,
        repo: repo,
        github_webhook_id: hook_id
      )
    end
  end
end
