module Github
  class InviteUserToOrg
    include CallableService
    include GithubService

    attribute :org, Org
    attribute :username, String

    def call
      options = {
        user: username,
        role: 'admin'
      }

      if Shepherd::ORGS_API_PREVIEW
        options[:accept] = 'application/vnd.github.moondragon-preview+json'
      end

      response = github_client.update_organization_membership(
        org.name,
        options
      )
    end
  end
end
