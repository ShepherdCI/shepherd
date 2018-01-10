class VerifyWebhookPayloadSignature
  include CallableService
  include Virtus.model

  HMAC_DIGEST = OpenSSL::Digest.new('sha1')

  attribute :secret, String
  attribute :request

  def call
    raise 'secret cannot be blank' unless secret.present?

    expected_signature = "sha1=#{OpenSSL::HMAC::hexdigest(HMAC_DIGEST, secret, request.raw_post)}"

    if request.headers['X-Hub-Signature'] == expected_signature
      return Success.new
    else
      return InvalidPayloadSignatureError.new
    end
  end
end
