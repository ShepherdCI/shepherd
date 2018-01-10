module GithubSync
  extend ActiveSupport::Concern

  def create_or_update_model
    if model = model_class.find_by(github_id: self.id)
      model.update_attributes(model_attributes)
    else
      model = model_class.create(model_attributes)
    end

    model
  end

  private
  def model_class
    self.class.model_class
  end
end
