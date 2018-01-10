class FindOrCreateRepository
  include CallableService

  attribute :repo_name, String

  def call
    if repo = Repo.find_by(full_github_name: repo_name)
      return repo
    end

    gh_repo = Github::GetRepo.call(repo_name: repo_name, access_token: Shepherd::GITHUB_TOKEN)

    Repo.upsert_github_model(gh_repo)
  end
end
