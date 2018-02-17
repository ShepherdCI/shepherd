require 'rails_helper'

shared_examples 'a webhook resource' do
  let(:raw_payload) { payload.to_json }
  subject(:make_request) do
    post "/webhooks/#{request_prefix}/#{requested_resource}", params: raw_payload, headers: headers
  end

  let(:payload) { { foo: 'bar' } }
  let(:headers) { {} }

  let!(:hookable) do
    FactoryBot.create(model.name.downcase,
                      github_webhook_secret: 'sekret',
                      canonical_name: canonical_name
                     )
  end

  context 'repo identifier does not match an existing repo' do
    let(:requested_resource) { invalid_name }

    it 'should return a 404' do
      make_request

      expect(response.status).to eq 404
    end
  end

  context 'repo identifier matches an existing repo' do
    let(:requested_resource) { canonical_name }

    context 'headers do not include signature' do
      let(:headers) do
        {
          "ACCEPT" => "application/json",
          "HTTP_X_GITHUB_EVENT" => 'push'
        }
      end

      it 'should return a validation error' do
        make_request

        expect(response.status).to eq 403
        expect(response.body).to eq "The provided payload signature did not match the expected signature"
      end
    end

    context 'headers include an incorrect signature' do
      let(:headers) do
        {
          "accept" => "application/json",
          "http_x_github_event" => 'push',
          'x-hub-signature' => '12345'
        }
      end

      it 'should return a validation error' do
        make_request

        expect(response.status).to eq 403
        expect(response.body).to eq "The provided payload signature did not match the expected signature"
      end
    end

    context 'headers include a correct signature' do
      let(:headers) do
        {
          "ACCEPT" => "application/json",
          "HTTP_X_GITHUB_EVENT" => 'push',
          'X-Hub-Signature' => "sha1=#{OpenSSL::HMAC::hexdigest(WebhookPayloadVerifier::HMAC_DIGEST, 'sekret', raw_payload)}"
        }
      end

      it 'should return a success status' do
        make_request

        expect(response.status).to eq 201
      end

      fit 'should enqueue the event for processing' do
        expect {
          make_request
        }.to have_enqueued_job(ProcessWebhookPayloadJob).with(hookable, 'push', payload.as_json)
      end
    end
  end
end

describe 'Github Webhook', type: :request do
  describe 'Repository' do
    it_behaves_like 'a webhook resource' do
      let(:model)          { Project }
      let(:canonical_name) { 'group/repo_name' }
      let(:invalid_name)   { 'iam/notarepo' }
      let(:request_prefix) { 'repo' }
    end
  end

  describe 'Organization' do
    it_behaves_like 'a webhook resource' do
      let(:model)          { Organization }
      let(:canonical_name) { 'org_name' }
      let(:invalid_name)   { 'missing_org' }
      let(:request_prefix) { 'org' }
    end
  end
end

