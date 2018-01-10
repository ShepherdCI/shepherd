module Github
  class GetTokenScope
    include CallableService
    include GithubService

    def call
      result = github_client.scopes

      Authentication::OauthScope.new(result)
    end
  end
end
