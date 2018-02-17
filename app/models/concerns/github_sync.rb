module GithubSync
  extend ActiveSupport::Concern

  def upsert_model
    model_class.upsert(model_attributes, finder: { github_id: self.id })
  end

  private
  def model_class
    self.class.model_class
  end
end
