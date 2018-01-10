module Github
  class GetRepo
    include CallableService
    include GithubService

    attribute :repo_name, String

    def call
      response = github_client.repository(repo_name)

      Success.new(Github::Repository.new(response))
    end
  end
end
