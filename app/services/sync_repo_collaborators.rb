class SyncRepoCollaborators
  include CallableService

  attribute :repo, Repo
  attribute :user, User

  def call
    result = Github::GetRepoCollaborators.call(repo: repo, access_token: user.token)

    return result unless result.success?

    raw_tuples = result.data

    users = User.upsert_github_model(raw_tuples.map(&:first))

    user_perm_tuples = users.zip(raw_tuples.map(&:last))

    Membership.transaction do
      user_perm_tuples.each do |(user, permissions)|
        Membership.upsert(
          user: user,
          object: repo,
          admin: permissions.admin?
        )
      end

      out_of_date = Membership.where(object: repo).where("user_id NOT IN (?)", users.map(&:id))
      out_of_date.map(&:destroy)
    end

    users
  end
end
