class Credential
  include ActiveModel::Model
  attr_accessor :user

  delegate :name, :avatar_url, :github_login, to: :user

  def id
    @id ||= SecureRandom.uuid
  end

  def jwt
    user.mint_jwt
  end
end
