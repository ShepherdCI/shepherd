module Github
  class Repository
    class Permissions
      include Virtus.model

      attribute :admin, Boolean
      attribute :push, Boolean
      attribute :pull, Boolean
    end
  end
end
