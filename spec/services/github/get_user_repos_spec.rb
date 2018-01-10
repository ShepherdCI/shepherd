require 'spec_helper'

describe Github::GetUserRepos do
  let(:callable) { described_class.new(github_client: github_stub) }
  let(:github_stub) { double('Octokit::Client') }

  subject(:get_user_repos) { callable.call }

  context "User's repo list returned from github" do
    before do
      allow(github_stub).to receive(:repos).and_return(load_json_fixture('github', 'user_repos.json'))
    end

    it 'should return a success status' do
      expect(get_user_repos).to be_kind_of(Success)
    end

    it 'should put a list of repos in the success data' do
      repos = get_user_repos.data

      repos.each { |r| expect(r.class).to be Github::Repository }

      expect(repos.map(&:name)).to eq ['actionform', 'bb-paginate', 'shepherd']
    end
  end
end
