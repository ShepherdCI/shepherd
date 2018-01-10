class Github::Team
  include Virtus::Model
  include Github::ModelSync

  attribute :id, Integer
  attribute :name, String
  attribute :slug, String
  attribute :description, String
  attribute :organization, Github::Organization

  def self.shepherd_model
    ::Team
  end

  def to_shepherd_attrs
    attrs = {
      github_id:   id,
      name:        name,
      slug:        slug,
      description: description,
    }

    if organization
      attrs[:org] = organization.sync_shepherd_model
    end

    attrs
  end
end
