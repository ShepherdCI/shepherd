require 'spec_helper'

describe Github::AddRepoCollaborator do
  let(:repo) { double('Repo', full_github_name: 'user/repo_name') }
  let(:client) { double('Octokit::Client', add_collaborator: api_response) }
  let(:api_response) { nil }

  subject { described_class.call(repo: repo, username: 'shepherd_user', github_client: client) }

  it 'should add a collaborator via the github api' do
    subject

    expect(client).to have_received(:add_collaborator).with('user/repo_name', 'shepherd_user', accept: "application/vnd.github.ironman-preview+json")
  end

  context 'raises UnprocessableEntity exception' do
    # This error constructor is overridden by ocktokit to build the message from the request, so let's just manually construct it.
    let(:error) do
      e = Octokit::UnprocessableEntity.new
      allow(e).to receive(:message).and_return(error_message)
      e
    end

    before do
      allow(client).to receive(:add_collaborator).and_raise(error)
    end

    context 'User is already a member of the repo' do
      let(:error_message) do
        <<ERROR
PUT https://api.github.com/repos/wadetandy/shepherd/collaborators/ShepherdCI: 422 - Validation Failed
Error summary:
  resource: Repository
  code: custom
  message: You can only update permissions on organization-owned repositories and their forks // See: https://developer.github.com/v3/repos/collaborators/#add-user-as-a-collaborator
ERROR
       end

      it 'should return success' do
        expect(subject).to be_success
      end
    end

    context 'It is another error' do
      let(:error_message) { 'unhandled message' }

      it 'should raise the error' do
        expect { subject }.to raise_error(Octokit::UnprocessableEntity)
      end
    end

  end
end
