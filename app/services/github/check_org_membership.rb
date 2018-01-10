module Github
  class CheckOrgMembership
    include CallableService
    include GithubService

    attribute :org, Org
    attribute :user, User

    def call
      github_client.organization_member?(org.name, user.github_username)
    end
  end
end
