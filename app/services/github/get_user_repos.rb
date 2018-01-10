module Github
  class GetUserRepos
    include CallableService
    include GithubService

    def call
      response = github_client.repos(nil, affiliation: 'collaborator,owner')

      repos = response.map do |repo|
        Github::Repository.new(repo)
      end

      Success.new(repos)
    end
  end
end
