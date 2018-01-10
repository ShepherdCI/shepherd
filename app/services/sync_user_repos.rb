class SyncUserRepos
  include CallableService

  attribute :user, User

  def call

    status = Github::GetUserRepos.call(access_token: user.token)

    if status.success?
      repos = []

      Repo.transaction do
        user.clear_repos

        gh_repos = status.data

        gh_repos.each do |gh_repo|
          repo = Repo.upsert_github_model(gh_repo).first
          repos << repo

          Membership.upsert(
            user: user,
            object: repo,
            admin: gh_repo.permissions.admin,
          )
        end
      end

      Success.new(repos)
    else
      status
    end
  end
end
