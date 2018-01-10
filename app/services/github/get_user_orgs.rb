module Github
  class GetUserOrgs
    include CallableService
    include GithubService

    def call
      response = github_client.orgs

      orgs = response.map do |org|
        Github::Organization.new(org)
      end

      Success.new(orgs)
    end
  end
end
