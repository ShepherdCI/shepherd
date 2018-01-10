class CredentialResource < ApplicationResource
  use_adapter JsonapiCompliable::Adapters::Null
  type :credentials
  model Credential

  def resolve(scope)
    raise NotImplementedError
  end

  allow_sideload :user, resource: UserResource, type: :belongs_to do
    scope { }
    assign { }
  end
end
