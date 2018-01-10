class SyncOrgRepos
  include CallableService

  attribute :org, Org

  def call
    status = Github::GetOrgRepos.call(org: org, access_token: Shepherd::GITHUB_TOKEN)

    if status.success?
      repos = []

      Repo.transaction do
        org.clear_repos

        gh_repos = status.data

        gh_repos.each do |gh_repo|
          repo = Repo.upsert_github_model(gh_repo).first
          repos << repo
        end
      end

      repos
    else
      raise status.message
    end
  end
end
