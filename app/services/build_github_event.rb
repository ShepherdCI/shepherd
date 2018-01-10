class BuildGithubEvent
  include CallableService

  attribute :hook, RegisteredHook
  attribute :payload, Hash
  attribute :headers, Hash

  def call
    type = headers['HTTP_X_GITHUB_EVENT']

    if GithubEvent.supports_type?(type)
      GithubEvent.build(type, payload: payload, hook: hook)
    end
  end
end
