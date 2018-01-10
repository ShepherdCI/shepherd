class UpdateCommitStatus
  include CallableService
  include ServicesHelper

  attribute :status_object, Object
  attribute :state, String
  attribute :description, String, default: "Shepherd CI"
  attribute :context, String

  def call
    Github::UpdateCommitStatus.call(
      repo: repo,
      sha: commit.sha,
      state: state,
      description: description,
      context: context,
      target_url: ci_status_url,
      access_token: Shepherd::GITHUB_TOKEN
    )
  end

  private

  def commit
    status_object.commit
  end

  def repo
    status_object.repo
  end

  def ci_status_url
    status_object.ci_status_url
  end
end
