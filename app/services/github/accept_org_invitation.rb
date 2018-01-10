module Github
  class AcceptOrgInvitation
    include CallableService
    include GithubService

    attribute :org, Org

    def call
      options = {
        state: 'active'
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
