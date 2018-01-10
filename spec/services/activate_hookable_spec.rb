require "spec_helper"

describe ActivateHookable do
  let(:user) { FactoryGirl.build(:user) }
  let(:repo) { FactoryGirl.build(:repo) }

  let(:activator) { -> {} }

  subject { described_class.call(user: user, hookable: repo, activator: activator) }

  it 'should call the activator' do
    expect(activator).to receive(:call).with(user: user, hookable: repo)

    subject
  end
end
