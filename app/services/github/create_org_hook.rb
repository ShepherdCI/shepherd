module Github
  class CreateOrgHook
    include CallableService
    include GithubService

    attribute :org, Org
    attribute :secret, String
    attribute :callback_url, String

    def call
      options = {
        active: true,
        events: ['*'],
      }

      if Shepherd::ORGS_API_PREVIEW
        options[:accept] = 'application/vnd.github.sersi-preview+json'
      end

      hook = github_client.create_org_hook(
        org.name,
        {
          url: callback_url,
          content_type: 'json',
          secret: secret,
          insecure_ssl: (Shepherd::VERIFY_SSL_GITHUB_WEBHOOKS ? '0' : '1'),
        },
        options
      )

      if block_given?
        yield hook
      else
        hook
      end
    end
  end
end
