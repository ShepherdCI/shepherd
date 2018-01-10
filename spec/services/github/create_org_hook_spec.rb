require 'spec_helper'

describe Github::CreateOrgHook do
  let(:org) { double('Org', name: 'testorg') }
  let(:secret) { 'iamasecret' }
  let(:callback_url) { 'http://example.com/callback_path' }

  let(:client) { double('Octokit::Client', create_org_hook: api_response) }
  let(:api_response) { :hook_response }

  subject { described_class.call(org: org, secret: secret, callback_url: callback_url, github_client: client) }

  context 'ssl verification enabled' do
    before do
      stub_const('Shepherd::VERIFY_SSL_GITHUB_WEBHOOKS', true)
    end

    it 'should create a hook via the github api' do
      subject

      expect(client).to have_received(:create_org_hook).with(
        'testorg',
        {
          url: 'http://example.com/callback_path',
          content_type: 'json',
          secret: 'iamasecret',
          insecure_ssl: '0',
        },
        {
          active: true,
          events: ['*'],
        }
      )
    end
  end

  context 'ssl verification disabled' do
    before do
      stub_const('Shepherd::VERIFY_SSL_GITHUB_WEBHOOKS', false)
    end

    it 'should create a hook via the github api' do
      subject

      expect(client).to have_received(:create_org_hook).with(
        'testorg',
        {
          url: 'http://example.com/callback_path',
          content_type: 'json',
          secret: 'iamasecret',
          insecure_ssl: '1',
        },
        {
          active: true,
          events: ['*'],
        }
      )
    end
  end

  context 'Github organization hooks API is in preview mode' do
    before do
      stub_const('Shepherd::ORGS_API_PREVIEW', true)
    end

    it 'should include the preview accept header' do
      subject

      expect(client).to have_received(:create_org_hook).with(
        kind_of(String),
        kind_of(Hash),
        hash_including(accept: 'application/vnd.github.sersi-preview+json')
      )
    end
  end
end
