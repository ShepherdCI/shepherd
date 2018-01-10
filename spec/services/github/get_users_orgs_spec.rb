require 'spec_helper'

describe Github::GetUserOrgs do
  let(:callable) { described_class.new(github_client: github_stub) }
  let(:github_stub) { double('Octokit::Client') }

  subject(:get_user_orgs) { callable.call }

  context "User's org list returned from github" do
    before do
      allow(github_stub).to receive(:orgs).and_return(load_json_fixture('github', 'user_orgs.json'))
    end

    it 'should return a success status' do
      expect(get_user_orgs).to be_kind_of(Success)
    end

    it 'should put a list of orgs in the success data' do
      orgs = get_user_orgs.data

      orgs.each { |r| expect(r.class).to be Github::Organization }

      expect(orgs.map(&:login)).to eq ['rails', 'bloomberg']
    end
  end
end
