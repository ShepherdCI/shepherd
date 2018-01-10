require 'spec_helper'

describe AddRoleUserToOrg, type: :service do
  let(:user) { double('User', token: :github_token) }
  let(:org) { double('Org', full_github_name: 'TestOrg') }

  before do
    allow(Github::InviteUserToOrg).to receive(:call)
    allow(Github::AcceptOrgInvitation).to receive(:call)

    stub_const('Shepherd::GITHUB_USERNAME', 'shepherd_role_account')
    stub_const('Shepherd::GITHUB_TOKEN', 'shepherd_auth_token')
  end

  subject { described_class.call(user: user, org: org) }

  it 'should invite the shepherd user to the organization' do
    expect(Github::InviteUserToOrg).to receive(:call).with(
      org: org,
      username: 'shepherd_role_account',
      access_token: :github_token,
    )

    subject
  end

  it 'should accept the invitation on behalf of the role user' do
    expect(Github::AcceptOrgInvitation).to receive(:call).with(
      org: org,
      access_token: 'shepherd_auth_token',
    )

    subject
  end
end
