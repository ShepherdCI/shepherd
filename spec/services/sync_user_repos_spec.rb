require "rails_helper"

describe SyncUserRepos do
  let(:user) { FactoryGirl.create(:user) }
  subject(:sync_repos) { described_class.call(user: user) }

  context 'Github returns a successful result' do
    let(:github_result) { load_json_fixture('github', 'user_repos.json').map {|r| Github::Repository.new(r)} }

    before do
      allow(Github::GetUserRepos).to receive(:call).and_return Success.new(github_result)

      allow(user).to receive(:clear_repos)
    end

    it 'should clear out existing user repos' do
      expect(user).to receive(:clear_repos)

      sync_repos
    end

    it 'should return the updated repos in a success status' do
      result = sync_repos
      expect(result).to be_success
      expect(result.data).to eq Repo.all
    end

    context 'database is empty' do
      it 'should insert results into database' do
        sync_repos

        repos = Repo.all

        expect(repos.count).to eq 3
      end

      it 'should give the user appropriate memberships' do
        result = sync_repos.data

        memberships = Membership.where(user: user)

        expect(memberships.count).to eq 3
        expect(memberships.map(&:object)).to eq result
      end
    end

    context 'multiple existing memberships to affected repos' do
      let(:other_user) { FactoryGirl.create(:user, github_username: 'other_user') }
      let(:shepherd_repo) { FactoryGirl.create(:repo, github_id: 53509934, full_github_name: 'wadetandy/shepherd') }

      before do
        Membership.upsert(user: user, object: shepherd_repo, admin: false)
        Membership.upsert(user: other_user, object: shepherd_repo, admin: false)
      end

      it "should not affect other users' membership in the repo" do
        sync_repos

        expect(Membership.find_by(user: other_user, object: shepherd_repo)).to be_present
      end
    end
  end

  context 'github return an error result' do
    let(:error) { Error.new('I am an error') }

    before do
      allow(Github::GetUserRepos).to receive(:call).and_return error
    end

    it 'should return the error' do
      expect(sync_repos).to eq error
    end
  end
end
