require 'spec_helper'

describe Github::InviteUserToOrg do
  let(:org) { double('Org', name: 'TestOrg') }
  let(:client) { double('Octokit::Client', update_organization_membership: api_response) }
  let(:api_response) { nil }

  subject { described_class.call(org: org, username: 'shepherd_user', github_client: client) }
  it 'should add a team member via the github api' do
    subject

    expect(client).to have_received(:update_organization_membership).with('TestOrg', user: 'shepherd_user', role: 'admin')
  end

  context 'Github organization API is in preview mode' do
    before do
      stub_const('Shepherd::ORGS_API_PREVIEW', true)
    end

    it 'should include the preview accept header' do
      subject

      expect(client).to have_received(:update_organization_membership).with(
        'TestOrg',
        hash_including(accept: 'application/vnd.github.moondragon-preview+json')
      )
    end
  end
end
