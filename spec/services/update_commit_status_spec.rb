require 'spec_helper'

describe UpdateCommitStatus do
  let(:commit) { double('Ci::Commit', sha: 'abc123') }
  let(:repo) { double('Repo', id: 'repo1') }
  let(:build) { double('Ci::Build', id: 'build4', repo: repo, commit: commit, ci_status_url:'http://test.host/ci/builds/build4' ) }

  subject do
    described_class.call(
      status_object: build,
      state: 'state_text',
      description: 'description_text',
      context: 'context_text'
    )
  end

  before do
    allow(GetRepoToken).to receive(:call).and_return(:repo_access_token)
    stub_const('Shepherd::GITHUB_TOKEN', 'role_user_github_token')
  end

  it 'should update the commit status via github' do
    expect(Github::UpdateCommitStatus).to receive(:call).with(
      repo: repo,
      sha: 'abc123',
      state: 'state_text',
      description: 'description_text',
      context: 'context_text',
      target_url: 'http://test.host/ci/builds/build4',
      access_token: 'role_user_github_token'
    )

    subject
  end
end
