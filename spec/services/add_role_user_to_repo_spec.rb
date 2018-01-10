require 'spec_helper'

describe AddRoleUserToRepo, type: :service do
  let(:user) { double('User', token: :github_token) }
  let(:repo) { double('Repo', full_github_name: 'foo/bar') }

  describe '#call' do
    let(:instance) { described_class.new(user: user, repo: repo) }

    it 'should add a collaborator via github' do
      expect(Github::AddRepoCollaborator).to receive(:call).with(repo: repo, username: Shepherd::GITHUB_USERNAME, access_token: user.token)

      instance.call
    end
  end
end
