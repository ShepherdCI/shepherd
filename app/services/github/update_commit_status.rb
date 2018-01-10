module Github
  class UpdateCommitStatus
    include CallableService
    include GithubService

    attribute :repo, Repo
    attribute :sha, String
    attribute :state, String
    attribute :description, String
    attribute :context, String
    attribute :target_url, String

    def call
      github_client.create_status(
        repo.full_github_name,
        sha,
        state,
        description: description,
        context: context,
        target_url: target_url
      )
    end
  end
end
