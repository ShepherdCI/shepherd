require "spec_helper"

describe DeactivateHookable do
  let(:user) { FactoryGirl.build(:user) }
  let(:repo) { FactoryGirl.build(:repo) }

  let(:deactivator) { -> {} }

  subject { described_class.call(user: user, hookable: repo, deactivator: deactivator) }

  it 'should call the deactivator' do
    expect(deactivator).to receive(:call).with(user: user, hookable: repo)

    subject
  end
end
