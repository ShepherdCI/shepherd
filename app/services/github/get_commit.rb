module Github
  class GetCommit
    include CallableService
    include GithubService

    attribute :repo_name, String
    attribute :sha, String

    def call
      response = github_client.commit(repo_name, sha)

      attrs = response['commit']

      attrs['sha'] = response['sha']
      attrs['author']['username'] = MaybeHash.chain(response, 'author', 'login')
      attrs['committer']['username'] = MaybeHash.chain(response, 'committer', 'login')
      attrs['timestamp'] = MaybeHash.chain(attrs, 'committer', 'date')

      Success.new(Github::Commit.new(attrs))
    end
  end
end
