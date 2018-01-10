module Github
  class Organization
    include GithubSync

    attribute :name, String
    attribute :login, String
    attribute :id, Integer
    attribute :name, String
    attribute :description, String
    attribute :company, String
    attribute :avatar_url, URI
    attribute :html_url, URI

    def self.model_class
      ::Org
    end

    def model_attributes
      {
        github_login: login,
        github_id:    id,
        avatar_url:   avatar_url,
        name:         name,
        description:  description,
        company:      company,
      }.compact
    end
  end
end
