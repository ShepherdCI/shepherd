require 'openssl'

class WebhookPayloadVerifier
  HMAC_DIGEST = OpenSSL::Digest.new('sha1')

  def verify(secret:, request:)
    raise 'secret cannot be blank' unless secret.present?

    expected_signature = "sha1=#{OpenSSL::HMAC::hexdigest(HMAC_DIGEST, secret, request.raw_post)}"

    if request.headers['X-Hub-Signature'] == expected_signature
      true
    else
      false
    end
  end
end
