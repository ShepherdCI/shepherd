module Github
  class GetOrgMembers
    include CallableService
    include GithubService

    attribute :org, Org
    attribute :role, String

    def call
      response = github_client.org_members(org.name, role: role)

      users = response.map do |user|
        Github::User.new(user)
      end

      Success.new(users)
    end
  end
end
