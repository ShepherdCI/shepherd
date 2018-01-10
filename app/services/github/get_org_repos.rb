module Github
  class GetOrgRepos
    include CallableService
    include GithubService

    attribute :org, Org

    def call
      response = github_client.org_repos(org.name)

      repos = response.map do |repo|
        Github::Repository.new(repo)
      end

      Success.new(repos)
    end
  end
end
