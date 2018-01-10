module Github
  class CreateRepoHook
    include CallableService
    include GithubService

    attribute :repo, Repo
    attribute :secret, String
    attribute :callback_url, String

    def call
      hook = github_client.create_hook(
        repo.full_github_name,
        "web",
        {
          url: callback_url,
          content_type: 'json',
          secret: secret,
          insecure_ssl: (Shepherd::VERIFY_SSL_GITHUB_WEBHOOKS ? '0' : '1'),
        },
        {
          active: true,
          events: ['*'],
        }
      )

      if block_given?
        yield hook
      else
        hook
      end
    end
  end
end
