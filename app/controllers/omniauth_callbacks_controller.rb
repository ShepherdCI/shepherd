class OmniauthCallbacksController < FullStackControllerBase
  def github
    gh_user = Github::User.new(request.env['omniauth.auth']['extra']['raw_info'])

    unless scopes = Github::GetTokenScope.call(access_token: access_token)
      render_error('invalid scope request')
      return
    end

    user = gh_user.create_or_update_model

    if user.persisted?
      unless (user.oauth_scope - scopes).present?
        user.update_attributes!(github_token: access_token, github_token_scopes: scopes)
      end

      render_success(user)
    else
      render_error(user)
    end
  end

  private

  def render_error(user)
    # error = Credential.new(user: user)

    render_json(JSONAPI::Serializable::ErrorRenderer.new) do |renderer|
      renderer.render(error)
    end

    render 'window_messenger', layout: false
  end

  def render_success(user)
    credential = Credential.new(user: user)

    credential_json = SerializableCredential.new(object: credential).as_jsonapi(include: [:user])
    user_json = SerializableUser.new(object: user).as_jsonapi

    render_json(
      data: credential_json,
      included: [user_json],
    )
  end

  def render_json(payload)
    @payload = WindowMessengerEnvelope.new(type: 'OauthResponse', payload: payload).to_json

    render 'window_messenger', layout: false
  end

  def access_token
    request.env["omniauth.auth"]["credentials"]["token"]
  end
end
