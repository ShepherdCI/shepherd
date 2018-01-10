require 'spec_helper'

describe Github::GetOrg do
  let(:callable) { described_class.new(org_name: 'testOrg', github_client: github_stub) }
  let(:github_stub) { double('Octokit::Client') }

  subject { callable.call }

  it 'should request the org from github' do
    expect(github_stub).to receive(:org).with('testOrg').and_return({})

    subject
  end

  context 'User is not permissioned for the resource' do
    before do
      allow(github_stub).to receive(:org).and_raise(Octokit::Forbidden)
    end

    it 'should return an error' do
      expect(subject).to be_kind_of(GithubAuthorizationError)
    end
  end

  context 'Request returns the requested org' do
    before do
      payload = load_json_fixture('github', 'org.json')
      allow(github_stub).to receive(:org).and_return(payload)
    end

    it 'should return a success status' do
      expect(subject).to be_success
    end

    it 'should return the Github Organization object' do
      payload = subject.data

      expect(payload).to be_kind_of Github::Organization
      expect(payload.login).to eq 'octocat'
    end
  end
end
