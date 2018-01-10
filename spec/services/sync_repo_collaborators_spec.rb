require 'rails_helper'

describe SyncRepoCollaborators do
  let(:repo) { create(:repo) }
  let(:user) { create(:user, token: 'usertoken') }

  before do
    repo.collaborators = repo_members
  end

  let(:repo_members) { [] }
  let(:gh_users) do
    [
      {
        login: "wadetandy",
        id: 148470
      },
      {
        login: 'admin',
        id: 92349
      }
    ].map{|u| Github::User.new(u)}
  end

  let(:repo_permissions) do
    [
      {
        admin: true,
        push: true,
        pull: true,
      },
      {
        admin: false,
        push: false,
        pull: true,
      }
    ].map{|p| Github::RepoPermissions.new(p)}
  end

  let(:tuples) do
    gh_users.zip(repo_permissions)
  end

  before do
    allow(Github::GetRepoCollaborators).to receive(:call).and_return(Success.new(tuples))
  end

  subject(:call_service) { described_class.call(user: user, repo: repo) }

  describe '#call' do
      it 'should get the details for the repo on behalf of the user' do
      expect(Github::GetRepoCollaborators).to receive(:call)
        .with(repo: repo, access_token: 'usertoken')
        .and_return(Success.new([]))

      call_service
    end

    context 'repo has no existing members' do
      it 'should add both users to the membership' do
        call_service

        repo.reload

        expect(repo.collaborators.map(&:github_username)).to eq ['wadetandy', 'admin']
      end
    end

    context 'repo has one existing member who is still a member' do
      let(:repo_members) do
        [
          create(:user, github_username: 'wadetandy')
        ]
      end

      it 'should add the new users to the repo membership' do
        call_service

        repo.reload

        expect(repo.collaborators.map(&:github_username)).to eq ['wadetandy', 'admin']
      end
    end

    context 'repo has one out of date membership that should be removed' do
      let(:removed_user) { create(:user, github_username: 'NoLongerAMember') }
      let(:repo_members) do
        [
          create(:user, github_username: 'wadetandy'),
          removed_user
        ]
      end

      it 'should remove the out of date user' do
        call_service

        repo.reload

        expect(repo.collaborators).not_to include(removed_user)
      end
    end


  end
end
