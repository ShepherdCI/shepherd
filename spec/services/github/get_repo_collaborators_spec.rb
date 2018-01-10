require 'spec_helper'

describe Github::GetRepoCollaborators do
  let(:callable) { described_class.new(repo: repo, github_client: github_stub) }
  let(:github_stub) { double('Octokit::Client') }
  let(:repo) { FactoryGirl.build(:repo, full_github_name: 'owner/repo_name') }

  subject { callable.call }

  it 'should request the collaborators from github' do
    expect(github_stub).to receive(:collaborators).with('owner/repo_name').and_return([])

    subject
  end

  context 'User is not permissioned for the resource' do
    before do
      allow(github_stub).to receive(:collaborators).and_raise(Octokit::Forbidden)
    end

    it 'should return an error' do
      expect(subject).to be_kind_of(GithubAuthorizationError)
    end
  end

  context 'Request returns list of User - Permission Tuples' do
    before do
      payload = load_json_fixture('github', 'repo_collaborators.json')
      allow(github_stub).to receive(:collaborators).and_return(payload)
    end

    it 'should return a success status' do
      expect(subject).to be_success
    end

    it 'should return an array of github user objects' do
      payload = subject.data
      tuple = payload.first

      expect(payload).to be_kind_of Array
      expect(tuple.first).to be_kind_of Github::User
      expect(tuple.first.login).to eq 'wadetandy'
      expect(tuple.last).to be_kind_of Github::RepoPermissions
    end
  end
end
