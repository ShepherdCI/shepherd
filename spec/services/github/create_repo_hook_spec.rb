require 'spec_helper'

describe Github::CreateRepoHook do
  let(:repo) { double('Repo', full_github_name: 'user/testrepo') }
  let(:secret) { 'iamasecret' }
  let(:callback_url) { 'http://example.com/callback_path' }

  let(:client) { double('Octokit::Client', create_hook: api_response) }
  let(:api_response) { :hook_response }

  subject { described_class.call(repo: repo, secret: secret, callback_url: callback_url, github_client: client) }

  context 'ssl verification enabled' do
    before do
      stub_const('Shepherd::VERIFY_SSL_GITHUB_WEBHOOKS', true)
    end

    it 'should create a hook via the github api' do
      subject

      expect(client).to have_received(:create_hook).with(
        'user/testrepo',
        "web",
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

      expect(client).to have_received(:create_hook).with(
        'user/testrepo',
        "web",
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
end
