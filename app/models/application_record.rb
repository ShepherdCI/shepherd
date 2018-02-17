class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.upsert(attributes = {}, finder: { id: attributes[:id] })
    if record = self.find_by(finder)
      record.update_attributes(attributes)
    else
      record = self.create(attributes)
    end

    record
  end
end
