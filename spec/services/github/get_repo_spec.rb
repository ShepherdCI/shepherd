require 'spec_helper'

describe Github::GetRepo do
  let(:callable) { described_class.new(github_client: github_stub, repo_name: 'test_repo') }
  let(:github_stub) { double('Octokit::Client') }

  subject(:get_repo) { callable.call }

  context 'request is successful' do
    before do
      allow(github_stub).to receive(:repository).and_return(load_json_fixture('github', 'repository.json'))
    end

    it 'should return a success status' do
      expect(get_repo).to be_kind_of(Success)
    end

    it 'should put the repo info in the success data' do
      repo = get_repo.data

      expect(repo.class).to be Github::Repository
      expect(repo.name).to eq 'Hello-World'
    end
  end
end
