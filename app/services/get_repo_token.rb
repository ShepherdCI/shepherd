class GetRepoToken
  include CallableService

  attribute :repo, Repo

  def call
    if repo.in_organization?
      Shepherd::GITHUB_TOKEN
    else
      repo.owner.token
    end
  end
end
