class SerializableUser < JSONAPI::Serializable::Resource
  type :users

  attribute :name
  attribute :github_login
  attribute :avatar_url
end
