require 'rails_helper'

describe RegisterRepoHook do
  let(:user) { double('User', token: :github_token) }
  let(:repo) { FactoryGirl.create(:repo, private: repo_is_private, full_github_name: 'foo/bar', active: false, github_webhook_secret: 'supersecretkey') }
  let(:repo_is_private) { false }
  let(:github_hook_result) { {id: 1234} }

  before do
    stub_const('Shepherd::SHEPHERD_HOST_AND_PROTOCOL', 'http://test.example.com')
  end

  subject { described_class.call(user: user, hookable: repo) }

  before do
    allow(Github::CreateRepoHook).to receive(:call).and_return(github_hook_result)
    allow(AddRoleUserToRepo).to receive(:call)
  end

  context 'repo is private' do
    let(:repo_is_private) { true }

    it 'should add the role user as a collaborator to the repository' do
      expect(AddRoleUserToRepo).to receive(:call)

      subject
    end
  end

  context 'repo is public' do
    it 'should add the role user as a collaborator to the repository' do
      expect(AddRoleUserToRepo).to receive(:call)

      subject
    end
  end

  it 'should create a github repo hook' do
    expect(Github::CreateRepoHook).to receive(:call).with(
      access_token: :github_token,
      repo: repo,
      secret: 'supersecretkey',
      callback_url: 'http://test.example.com/webhooks/repo/foo/bar'
    )

    subject
  end

  it 'should update the repo with the id returned from the service' do
    subject

    expect(repo.github_webhook_id).to eq 1234
  end

  it 'should activate the repo' do
    expect(repo).not_to be_active

    subject

    expect(repo).to be_active
  end

  context 'the request to github raises an error' do
    before do
      allow(Github::CreateRepoHook).to receive(:call).and_raise
    end

    it 'should roll back all database changes' do
      expect { subject }.to raise_error RuntimeError

      expect(RegisteredHook.count).to eq 0
      expect(repo).not_to be_active
    end
  end
end
