require 'rails_helper'

describe UpdateService do
  let(:repo) { create(:repo, :with_collaborators, active: false) }
  let(:service) { create(:service, hookable: repo, active: false) }
  let(:user) { repo.collaborators.first }

  let(:params) { {active: true} }

  subject { described_class.call(
    user: user,
    service: service,
    params: params
  ) }

  before do
    allow(HookableActivationJob).to receive(:perform_later)
    allow(HookableDeactivationJob).to receive(:perform_later)
  end

  it 'should update the attributes' do
    subject

    expect(service).to be_active
  end

  it 'should return the service' do
    expect(subject).to eq service
  end

  context 'service is active' do
    let(:service) { create(:service, hookable: repo, active: true) }

    context 'active param is set to true' do
      let(:params) { {active: true} }

      context 'repo is currently active' do
        let(:repo) { create(:repo, :with_collaborators, active: true) }

        it 'should not call the activation job' do
          expect(HookableActivationJob).not_to receive(:perform_later)

          subject
        end
      end

      context 'repo is currently inactive' do
        let(:repo) { create(:repo, :with_collaborators, active: false) }

        it 'should not call the deactivation job' do
          expect(HookableActivationJob).to receive(:perform_later)

          subject
        end
      end
    end

    context 'active param is set to false' do
      let(:params) { {active: false} }

      context 'repo is currently active' do
        let(:repo) { create(:repo, :with_collaborators, active: true) }

        it 'should call the deactivation job' do
          expect(HookableDeactivationJob).to receive(:perform_later).with(repo, user)

          subject
        end
      end

      context 'repo is currently inactive' do
        let(:repo) { create(:repo, :with_collaborators, active: false) }

        it 'should not call the deactivation job' do
          expect(HookableDeactivationJob).not_to receive(:perform_later)

          subject
        end
      end
    end

  end

  context 'service is inactive' do
    let(:service) { create(:service, hookable: repo, active: false) }

    context 'active param is set to true' do
      let(:params) { {active: true} }

      context 'repo is currently active' do
        let(:repo) { create(:repo, :with_collaborators, active: true) }

        it 'should not call the activation job' do
          expect(HookableActivationJob).not_to receive(:perform_later)

          subject
        end
      end

      context 'repo is currently inactive' do
        let(:repo) { create(:repo, :with_collaborators, active: false) }

        it 'should call the activation job' do
          expect(HookableActivationJob).to receive(:perform_later).with(repo, user)

          subject
        end
      end
    end

    context 'active param is set to false' do
      let(:params) { {active: false} }

      context 'repo is currently active' do
        let(:repo) { create(:repo, :with_collaborators, active: true) }

        it 'should call the deactivation job' do
          expect(HookableDeactivationJob).to receive(:perform_later)

          subject
        end
      end

      context 'repo is currently inactive' do
        let(:repo) { create(:repo, :with_collaborators, active: false) }

        it 'should not call the deactivation job' do
          expect(HookableDeactivationJob).not_to receive(:perform_later).with(repo, user)

          subject
        end
      end
    end
  end
end
