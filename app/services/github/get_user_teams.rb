module Github
  class GetUserTeams
    include CallableService
    include GithubService

    def call
      response = github_client.user_teams

      teams = response.map do |team|
        Github::Team.new(team)
      end

      Success.new(teams)
    end
  end
end
