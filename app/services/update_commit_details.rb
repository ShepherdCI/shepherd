class UpdateCommitDetails
  include CallableService
  include Virtus.model

  attribute :commit, Ci::Commit

  def call
    status = Github::GetCommit.call(
      repo_name: commit.repo.full_github_name,
      sha: commit.sha,
      access_token: Shepherd::GITHUB_TOKEN
    )

    if status.success?
      commit.update_attributes!(status.data.to_shepherd_attrs)
    else
      raise status.message
    end
  end
end
