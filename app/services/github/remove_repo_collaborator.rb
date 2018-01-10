module Github
  class RemoveRepoCollaborator
    include CallableService
    include GithubService

    attribute :repo, Repo
    attribute :username, String

    def call
      response = github_client.remove_collaborator(
        repo.full_github_name,
        username,
        accept: "application/vnd.github.ironman-preview+json",
      )
    end
  end
end
