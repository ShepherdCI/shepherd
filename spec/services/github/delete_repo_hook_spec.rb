require 'rails_helper'

describe Github::DeleteRepoHook do
  let(:repo) { build(:repo, full_github_name: 'org/repo') }
  let(:hook_id) { '12345' }
  let(:github_stub) { double('Octokit::Client') }

  subject(:do_operation) { described_class.call(repo: repo, github_webhook_id: hook_id, github_client: github_stub) }

  it 'should delete the hook from github' do
    expect(github_stub).to receive(:remove_hook).with(
      'org/repo',
      12345,
    ).and_return(true)

    do_operation
  end

  context 'operation is successful' do
    before do
      allow(github_stub).to receive(:remove_hook).and_return(true)
    end

    it 'should return success status' do
      expect(do_operation).to be_success
    end
  end

  context 'operation is not successful but completes' do
    before do
      allow(github_stub).to receive(:remove_hook).and_return(false)
    end

    it 'should return success status' do
      expect(do_operation).to be_success
    end
  end

  context 'User is not permissioned for the resource' do
    before do
      allow(github_stub).to receive(:remove_hook).and_raise(Octokit::Forbidden)
    end

    it 'should return an error' do
      expect(do_operation).to be_kind_of(GithubAuthorizationError)
    end
  end
end
