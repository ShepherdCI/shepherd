module ServicesHelper
  extend ActiveSupport::Concern

  private

  def add_error(error)
    error_message = ErrorMessageTranslation.from_error_response(error)
    errors.push(error_message).compact!
  end

  def assemble_url(path)
    URI.join("#{protocol}://#{Shepherd::HOST}", path).to_s
  end
end
