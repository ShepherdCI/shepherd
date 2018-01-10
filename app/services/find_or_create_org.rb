class FindOrCreateOrg
  include CallableService

  attribute :org_name, String

  def call
    if org = Org.find_by(name: org_name)
      return org
    end

    status = Github::GetOrg.call(org_name: org_name, access_token: Shepherd::GITHUB_TOKEN)

    if status.success?
      Org.upsert_github_model(status.data)
    else
      raise status.message
    end
  end
end
