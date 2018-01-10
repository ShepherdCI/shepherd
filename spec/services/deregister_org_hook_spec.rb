require 'rails_helper'

describe DeregisterOrgHook do
  subject(:user) { build(:user, token: 'usertoken') }
  subject(:deregister) { described_class.call(hookable: org, user: user) }
  subject(:org) { build(:org, github_webhook_id: hook_id, active: true) }

  before do
    allow(Github::DeleteOrgHook).to receive(:call).and_return(Success.new)
  end

  context 'hook is present' do
    subject(:hook_id) { 12345 }

    it 'should remove the hook from github' do
      expect(Github::DeleteOrgHook).to receive(:call)
        .with({
          access_token: 'usertoken',
          org: org,
          github_webhook_id: hook_id.to_s
        }).and_return(Success.new)

      deregister
    end

    it 'should deactivate the org' do
      deregister

      expect(org).not_to be_active
    end

    it 'should return true' do
      expect(deregister).to eq true
    end

    context 'github operation returns an error' do
      before do
        allow(Github::DeleteOrgHook).to receive(:call).and_return(Error.new('Github Error'))
      end

      it 'should raise the error' do
        expect { deregister }.to raise_error('Github Error')
      end
    end
  end

  context 'hook is nil' do
    subject(:hook_id) { nil }

    it 'should not call to github' do
      expect(Github::DeleteOrgHook).not_to receive(:call)

      deregister
    end

    it 'should return true' do
      expect(deregister).to eq true
    end

    it 'should deactivate the org' do
      deregister

      expect(org).not_to be_active
    end
  end
end
