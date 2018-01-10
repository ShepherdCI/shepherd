class SyncUserOrgs
  include CallableService
  include Virtus.model

  attribute :user, User

  def call
    orgs_status = Github::GetUserOrgs.call(access_token: user.token)
    # teams_status = Github::GetUserTeams.call(access_token: user.token)
    teams_status = Success.new([])

    if orgs_status.success? && teams_status.success?
      orgs = []

      Org.transaction do
        user.clear_orgs

        gh_orgs = orgs_status.data
        gh_teams = teams_status.data

        orgs = Org.upsert_github_models(gh_orgs)

        teams = []

        gh_teams.each do |gh_team|
          team = gh_team.sync_shepherd_model

          teams << team
        end

        user.orgs = orgs
        user.teams = teams
      end

      Success.new(orgs)
    elsif orgs_status.error?
      orgs_status
    else
      teams_status
    end
  end
end
