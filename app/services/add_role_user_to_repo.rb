class AddRoleUserToRepo
  include CallableService
  include Virtus.model

  attribute :user, User
  attribute :repo, Repo

  def call
    Github::AddRepoCollaborator.call(repo: repo, username: Shepherd::GITHUB_USERNAME, access_token: user.token)
  end
end
