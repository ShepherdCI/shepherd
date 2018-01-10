class SyncOrgMemberships
  include CallableService
  include Virtus.model

  attribute :org, Org
  attribute :user, User

  def call
    token = user.token

    unless Github::CheckOrgMembership.call(
      org: org,
      user: user,
      access_token: token
    )
      return GithubAuthorizationError.new("Update Org Members", user: user, resource: org)
    end

    admin_result = Github::GetOrgMembers.call(org: org, role: 'admin', access_token: token)
    member_result = Github::GetOrgMembers.call(org: org, role: 'member', access_token: token)

    if admin_result.success? && member_result.success?
      Org.transaction do
        admin_users = User.upsert_github_models(admin_result.data)

        if admin_users.present?
          admin_users.each do |user|
            Membership.upsert(user: user, object: org, admin: true)
          end

          # Clean up members not in the current admin set
          out_of_date = Membership
            .where(object: org, admin: true)
            .where(["user_id NOT IN(?)", admin_users.map(&:id)])

          out_of_date.map(&:destroy)
        end

        member_users = User.upsert_github_models(member_result.data)

        member_users.each do |user|
          Membership.upsert(user: user, object: org, admin: false)
        end
      end
    elsif admin_result.error?
      return admin_result
    else
      return member_result
    end
  end
end
