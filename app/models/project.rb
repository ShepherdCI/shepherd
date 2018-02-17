class Project < ApplicationRecord
  belongs_to :owner, polymorphic: true
  belongs_to :parent, optional: true
  has_many :memberships

  alias_attribute :canonical_name, :full_name
end
