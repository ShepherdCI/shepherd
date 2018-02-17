class WebhooksController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound do |e|
    render status: 404, plain: 'Not Found'
  end

  def create_for_repo
    project = Project.find_by!(canonical_name: "#{params[:namespace]}/#{params[:name]}")
    process_hook(project)
  end

  def create_for_org
    org = Organization.find_by!(canonical_name: params[:name])
    process_hook(org)
  end

  private

  def process_hook(hookable)
    verifier = WebhookPayloadVerifier.new

    unless verifier.verify(secret: hookable.github_webhook_secret, request: request)
      render status: 403, plain: "The provided payload signature did not match the expected signature"
      return
    end

    enqueue(hookable)

    render status: 201, json: {
      message: "Webhook Recieved",
    }
  end

  def enqueue(hookable)
    payload = JSON.parse(request.raw_post)
    type = request.headers['HTTP_X_GITHUB_EVENT']

    ProcessWebhookPayloadJob.perform_later(hookable, type, payload)
  end
end
