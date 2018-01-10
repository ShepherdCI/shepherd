class AddRoleUserToOrg
  include CallableService
  include Virtus.model

  attribute :user, User
  attribute :org, Org

  def call
    Github::InviteUserToOrg.call(org: org, username: Shepherd::GITHUB_USERNAME, access_token: user.token)

    Github::AcceptOrgInvitation.call(org: org, access_token: Shepherd::GITHUB_TOKEN)
  end
end
