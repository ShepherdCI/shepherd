require 'spec_helper'

describe GetRepoToken do
  let(:repo) { FactoryGirl.build(:repo, in_organization: in_organization, owner: owner) }

  let(:owner) { FactoryGirl.build(:user) }

  subject { described_class.call(repo: repo) }

  before do
    stub_const('Shepherd::GITHUB_TOKEN', :shepherd_gh_token)
  end

  context 'repo is not in an organization' do
    let(:in_organization) { false }

    it "should use the owner's token" do
      allow(owner).to receive(:token).and_return(:owner_token)

      expect(subject).to eq :owner_token
    end
  end

  context 'repo is in an organization' do
    let(:in_organization) { true }

    it "should use the role user token" do
      expect(subject).to eq :shepherd_gh_token
    end
  end

end
