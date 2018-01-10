module Github
  class DeleteOrgHook
    include CallableService
    include GithubService

    attribute :org, Org
    attribute :github_webhook_id, Integer

    def call
      options = {
      }

      if Shepherd::ORGS_API_PREVIEW
        options[:accept] = 'application/vnd.github.sersi-preview+json'
      end

      begin
        hook_list = github_client.org_hooks(org.name, options)
      rescue Octokit::NotFound
        # If this returns a 404 then the user doesn't have access
        return GithubAuthorizationError.new(:delete_org_hook, resource: org)
      end

      hook_ids = hook_list.map { |h| h[:id] }

      # If the hook doesn't exist then it's been removed by someone
      # on github directly and we should clean it up
      return Success.new unless github_webhook_id.in? hook_ids

      if github_client.remove_org_hook(
        org.name,
        github_webhook_id,
        options
      )
        Success.new
      else
        raise "there was an issue removing hook with github ID #{github_webhook_id} for org #{org.name}"
      end
    end
  end
end
