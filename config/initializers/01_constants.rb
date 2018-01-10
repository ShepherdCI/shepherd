module Shepherd
  HTTPS_ENABLED ||= ENV.fetch("ENABLE_HTTPS") == "yes"
  GITHUB_CLIENT_ID ||= ENV.fetch("GITHUB_CLIENT_ID")
  GITHUB_CLIENT_SECRET ||= ENV.fetch("GITHUB_CLIENT_SECRET")

  GITHUB_API_URL ||= ENV.fetch('GITHUB_API_URL', 'api.github.com')
  GITHUB_HOST ||= ENV.fetch('GITHUB_HOST', "github.com")
  GITHUB_PROXY ||= ENV.fetch('GITHUB_PROXY', nil)
  VERIFY_SSL_GITHUB_WEBHOOKS ||= (ENV.fetch('VERIFY_SSL_GITHUB_WEBOOOKS', nil) == 'false')

  HOST ||= ENV.fetch("HOST")
  Rails.application.routes.default_url_options[:host] = Shepherd::HOST

  ROLE_USER_GITHUB_TOKEN ||= ENV.fetch("ROLE_USER_GITHUB_TOKEN")
  ROLE_USER_GITHUB_USERNAME ||= ENV.fetch("ROLE_USER_GITHUB_USERNAME")
  ROLE_USER = LazyObject.new { User.where('lower(github_username) = lower(?)', ROLE_USER_GITHUB_USERNAME).take }

  PROTOCOL = if Shepherd::HTTPS_ENABLED
    "https"
  else
    "http"
  end

  SHEPHERD_HOST_AND_PROTOCOL = "#{PROTOCOL}://#{HOST}"
end
