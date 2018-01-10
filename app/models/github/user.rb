module Github
  class User
    include Virtus::Model
    include GithubSync

    attribute :name, String
    attribute :email, String
    attribute :login, String
    attribute :id, Integer
    attribute :avatar_url, URI
    attribute :html_url, URI

    def self.model_class
      ::User
    end

    def model_attributes
      {
        email:        email,
        github_login: login,
        github_id:    id,
        name:         name,
        avatar_url:   avatar_url,
      }.compact
    end
  end
end
