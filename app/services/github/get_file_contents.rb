module Github
  class GetFileContents
    include CallableService
    include GithubService

    attribute :repo, Repo
    attribute :sha, String
    attribute :filename, String

    def call
      github_client.contents(repo.full_github_name, path: filename, ref: sha)
    rescue Octokit::NotFound
      nil
    end
  end
end
