module Github
  class DeleteRepoHook
    include CallableService
    include GithubService

    attribute :repo, Repo
    attribute :github_webhook_id, Integer

    def call
      result = github_client.remove_hook(
        repo.full_github_name,
        github_webhook_id,
      )

      # We don't actually care whether the operation returns successfully as long
      # as it completes without error. This takes care of problems where a user
      # has manually removed the hook.
      Success.new
    end
  end
end

