module Util
  class AddAuthToCloneUrl
    include CallableService

    attribute :url, String

    def call
      auth = "#{Shepherd::GITHUB_USERNAME}:#{Shepherd::GITHUB_TOKEN}@"
      url.sub(/^https?:\/\//) do |prefix|
        prefix + auth
      end
    end
  end
end
