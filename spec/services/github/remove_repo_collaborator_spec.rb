require 'spec_helper'

describe Github::RemoveRepoCollaborator do
  let(:repo) { double('Repo', full_github_name: 'user/repo_name') }
  let(:client) { double('Octokit::Client', remove_collaborator: api_response) }
  let(:api_response) { nil }

  subject { described_class.call(repo: repo, username: 'shepherd_user', github_client: client) }
  it 'should add a collaborator via the github api' do
    subject

    expect(client).to have_received(:remove_collaborator).with('user/repo_name', 'shepherd_user', accept: "application/vnd.github.ironman-preview+json")
  end
end
