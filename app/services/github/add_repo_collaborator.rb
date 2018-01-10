module Github
  class AddRepoCollaborator
    include CallableService
    include GithubService

    attribute :repo, Repo
    attribute :username, String

    def call
      response = github_client.add_collaborator(
        repo.full_github_name,
        username,
        :accept=>"application/vnd.github.ironman-preview+json"
      )

      Success.new(response)
    rescue Octokit::UnprocessableEntity => e
      # This is a misleading message that means the user is already a collaborator.  That's fine and let's carry on as if it never happened
      if e.message =~ /You can only update permissions on organization-owned repositories and their forks/
        return Success.new
      else
        raise e
      end
    end
  end
end
