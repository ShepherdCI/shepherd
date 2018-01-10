require 'spec_helper'
require 'authentication/oauth_scope'

describe Authentication::OauthScope do
  describe '.parse' do
    subject(:do_parse) { described_class.parse(input) }

    let(:input) { 'repo,user:email,admin:org' }

    it 'should return a GithubScope instance' do
      expect(do_parse).to be_kind_of described_class
    end

    it 'should have the correct scopes set' do
      expect(do_parse.scope_list).to eq [
        'repo',
        'user:email',
        'admin:org',
      ]
    end

    context 'input is nil' do
      let(:input) { nil }

      it 'should return a GithubScope instance' do
        expect(do_parse).to be_kind_of described_class
      end

      it 'should be an empty scope set' do
        expect(do_parse.scope_list).to eq []
      end
    end

    context 'input contains unsupported scope' do
      let(:input) { 'repo,foobarbaz,user:email,admin:org' }

      it 'drops unknown scopes' do
        expect(do_parse.scope_list).to eq [
          'repo',
          'user:email',
          'admin:org',
        ]
      end
    end
  end

  describe 'scope arithmetic' do
    let(:scope1) { described_class.parse(scope_string_1) }
    let(:scope2) { described_class.parse(scope_string_2) }
    let(:scope_string_1) { 'user:email,repo' }
    let(:scope_string_2) { 'user:email,admin:org_hook' }

    describe 'subtraction' do
      it 'delegates to array comparison' do
        expect(scope1 - scope2).to eq(['repo'])
      end
    end

    describe 'union' do
      it 'delegates to array comparison' do
        expect((scope1 | scope2).sort).to eq(['user:email', 'repo', 'admin:org_hook'].sort)
      end
    end

    describe 'intersection' do
      it 'delegates to array comparison' do
        expect(scope1 & scope2).to eq(['user:email'])
      end
    end
  end

  describe 'scope test methods' do
    let(:instance) { described_class.new(input) }
    {
      'repo' => 'repo',
      'user:email' => 'user',
      'admin:org' => 'org_admin',
    }.each_pair do |scope, method_name|
      describe "##{method_name}?" do
        context "#{scope} included in scope list" do
          let(:input) { [scope] }

          it 'should be true' do
            expect(instance).to(send("be_#{method_name}"))
          end
        end

        context "#{scope} not included in scope list" do
          let(:input) { ['notanactualscope'] }

          it 'should be false' do
            expect(instance).not_to(send("be_#{method_name}"))
          end
        end
      end
    end
  end

  describe '#with' do
    let(:instance) { described_class.new(input) }
    let(:input) { ['user:email'] }
    subject(:enhanced_scope) { instance.with('admin:org') }

    it 'should return a new scope instance with the additional scope included' do
      expect(instance).not_to eq enhanced_scope

      expect(enhanced_scope).to be_org_admin
      expect(enhanced_scope).to be_user
    end
  end
end
