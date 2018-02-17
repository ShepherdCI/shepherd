class ProcessWebhookPayloadJob < ApplicationJob
  def perform(hookable, event_type, json_payload)
  end
end
