class User < ApplicationRecord
  devise :omniauthable, :trackable

  def mint_jwt
    JWT.encode(jwt_payload, Shepherd::Application.secrets[:secret_key_base])
  end

  def oauth_scope
    @oauth_scope ||= Authentication::OauthScope.parse(self.github_token_scopes)
  end

  private

  def jwt_payload
    {
      data: {
        id:           id,
      }
    }
  end
end
