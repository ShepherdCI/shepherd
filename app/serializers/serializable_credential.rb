class SerializableCredential < JSONAPI::Serializable::Resource
  type :credentials

  attributes :jwt

  belongs_to :user, class: SerializableUser
end
