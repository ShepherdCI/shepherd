module Github
  class Repository
    include Virtus.model
    include Github::ModelSync

    attribute :id, Integer
    attribute :name, String
    attribute :full_name, String
    attribute :private, Boolean
    attribute :description, String
    attribute :fork, Boolean
    attribute :html_url, URI
    attribute :clone_url, URI

    attribute :owner, Hash

    attribute :organization, Github::Organization

    attribute :permissions, Github::Repository::Permissions

    def self.shepherd_model
      ::Repo
    end

    def owner
      return nil unless defined?(@owner) && @owner.present?

      if @owner.kind_of?(Hash)
        data = @owner.with_indifferent_access

        if data[:type] == Github::User::TYPE_STRING
          data = Github::User.new(data)
        elsif data[:type] == Github::Organization::TYPE_STRING
          data = Github::Organization.new(data)
        elsif data[:name]
          Github::User.new(
            login: data[:name],
            email: data[:email]
          )
        else
          raise "Unknown Org owner type: #{data[:type]}"
        end
      else
        return @owner
      end
    end

    def to_shepherd_attrs
      {
        private:          self.private,
        github_id:        id,
        full_github_name: full_name,
        fork:             self.fork,
        project_name:     name,
        owner:            owner ? owner.sync_shepherd_model : nil,
        in_organization:  owner.kind_of?(Github::Organization)
      }
    end
  end
end
