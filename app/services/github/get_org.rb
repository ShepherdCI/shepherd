module Github
  class GetOrg
    include CallableService
    include GithubService

    attribute :org_name, String

    def call
      response = github_client.org(org_name)

      Success.new(Github::Organization.new(response))
    rescue Octokit::Forbidden
      GithubAuthorizationError.new(:get_org, resource: org_name)
    end
  end
end
