class GetFileContents
  include CallableService

  attribute :commit, Ci::Commit
  attribute :repo, Repo, default: ->{ commit.repo }
  attribute :filename, String

  def call
    if data = Github::GetFileContents.call(
      repo: repo,
      sha: commit.sha,
      filename: filename,
      access_token: Shepherd::GITHUB_TOKEN
    )

      Base64.decode64(data[:content])
    end
  end
end
