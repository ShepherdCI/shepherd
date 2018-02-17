require 'spec_helper'

require 'webhook_payload_verifier'

describe WebhookPayloadVerifier do
  let(:request) { double('Rack::Request', raw_post: post_body, headers: request_headers) }

  let(:post_body) do
    '{ "type": "test", "message": "foobar" }'
  end

  let(:request_headers) { {} }

  let(:instance) { described_class.new }

  subject(:verify) { instance.verify(secret: secret, request: request) }

  context 'secret is blank' do
    let(:secret) { '' }

    it 'should raise an error' do
      expect { verify }.to raise_error(RuntimeError, 'secret cannot be blank')
    end
  end

  context 'secret is set' do
    let(:secret) { 'abc123' }

    context 'Provided signature matches payload' do
      let(:request_headers) do
        {
          'X-Hub-Signature' => 'sha1=1c3b453634cbd3270a4b98b00ef67408b932607c'
        }
      end

      it 'returns true' do
        expect(verify).to eq true
      end
    end

    context 'Provided signature does not matche payload' do
      let(:request_headers) do
        {
          'X-Hub-Signature' => 'sha1=iamwrong'
        }
      end

      it 'returns false' do
        expect(verify).to eq false
      end
    end
  end
end
