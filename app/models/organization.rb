class Organization < ApplicationRecord
  alias_attribute :canonical_name, :github_login
end
