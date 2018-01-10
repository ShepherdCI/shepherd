class RegisterRepoHook
  include ServicesHelper
  include CallableService
  include HookableAction

  attribute :repo, Repo, default: lambda {|service,_| service.hookable }

  def call
    AddRoleUserToRepo.call(user: user, repo: repo)

    register_hook do |hook_secret|
      github_hook = Github::CreateRepoHook.call(
        access_token: user.token,
        repo: repo,
        secret: hook_secret,
        callback_url: repo.webhook_url
      )

      github_hook[:id]
    end
  end
end
