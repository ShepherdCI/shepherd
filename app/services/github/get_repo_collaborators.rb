module Github
  class GetRepoCollaborators
    include CallableService
    include GithubService

    attribute :repo, Repo

    def call
      response = github_client.collaborators(repo.full_github_name)

      Success.new(response.map do |user|
        [Github::User.new(user), Github::RepoPermissions.new(user['permissions'])]
      end)
    rescue Octokit::Forbidden
      GithubAuthorizationError.new(:get_collaborators, resource: repo)
    end
  end
end
