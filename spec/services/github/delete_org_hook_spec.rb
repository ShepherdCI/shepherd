require 'rails_helper'

describe Github::DeleteOrgHook do
  let(:org) { build(:org, name: 'testOrg') }
  let(:hook_id) { '12345' }
  let(:github_stub) { double('Octokit::Client') }

  subject(:do_operation) { described_class.call(org: org, github_webhook_id: hook_id, github_client: github_stub) }

  context 'User can access org hooks' do
    before do
      allow(github_stub).to receive(:org_hooks).and_return(hook_list)
    end

    context 'hook id is not in the list of returned hooks' do
      let(:hook_list) { [{id: 45945}, {id: 94839}] }

      it 'should not make another call to github and return success' do
        expect(github_stub).not_to receive(:remove_org_hook)

        expect(do_operation).to be_success
      end
    end


    context 'hook id is in the list of returned hooks' do
      let(:hook_list) { [{id: 12345}, {id: 94839}] }

      it 'should delete the hook from github' do
        expect(github_stub).to receive(:remove_org_hook).with(
          'testOrg',
          12345,
          {}
        ).and_return(true)

        do_operation
      end

      context 'operation is successful' do
        before do
          allow(github_stub).to receive(:remove_org_hook).and_return(true)
        end

        it 'should return success status' do
          expect(do_operation).to be_success
        end
      end

      context 'operation is not successful' do
        before do
          allow(github_stub).to receive(:remove_org_hook).and_return(false)
        end

        it 'raise an error' do
          expect{ do_operation }.to raise_error(RuntimeError)
        end
      end
    end

  end

  context 'User cannot access org hooks' do
    before do
      allow(github_stub).to receive(:org_hooks).and_raise(Octokit::NotFound)
    end

    it 'should return an error' do
      expect(do_operation).to be_kind_of(GithubAuthorizationError)
    end
  end
end
