require 'rails_helper'

describe FindOrCreateOrg do
  subject { described_class.call(org_name: 'test_org') }

  let(:github_org) do
    Github::Organization.new(
      login: 'test_org',
      id: 1234
    )
  end

  before do
    allow(Github::GetOrg).to receive(:call)
  end

  context 'Org already exists in the local db' do
    let(:org) { double('Org') }
    before do
      allow(Org).to receive(:find_by).and_return(org)
    end

    it 'should return the org' do
      expect(subject).to eq org
    end

    it 'should not make a remote call to github' do
      expect(Github::GetOrg).not_to receive(:call)

      subject
    end
  end

  context 'Org does not exist locally' do

    it 'should get the org from github and add it to the app DB' do
      expect(Github::GetOrg).to receive(:call).and_return(Success.new(github_org))

      subject

      expect(Org.find_by(name: 'test_org').github_id).to eq 1234
    end

    context 'github returns an error status' do
      it 'should raise the error' do
        expect(Github::GetOrg).to receive(:call).and_return(Error.new('error message'))

        expect { subject }.to raise_error(RuntimeError, 'error message')
      end
    end
  end
end
