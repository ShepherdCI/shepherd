module Github
  class RepoPermissions
    include Virtus::Model

    attribute :admin, Boolean
    attribute :push, Boolean
    attribute :pull, Boolean
  end
end
