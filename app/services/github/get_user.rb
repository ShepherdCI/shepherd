module Github
  class GetUser
    include CallableService
    include GithubService

    attribute :username, String

    def call
      response = github_client.user(username)
    end
  end
end
