module Authentication
  class OauthScope
    SUPPORTED_SCOPES=%w[
      user:email
      repo
      admin:org
      admin:org_hook
    ]

    attr_reader :scope_list

    def initialize(scope_list)
      @scope_list = Array(scope_list).map(&:to_s)
    end

    def self.parse(input_str)
      if input_str.blank?
        values = []
      else
        values = input_str.split(',')
      end

      self.new(values & SUPPORTED_SCOPES)
    end

    def self.default
      self.new(default_scope)
    end

    def self.default_scope
      %w[user:email repo]
    end

    def self.full
      self.new(full_scope)
    end

    def self.full_scope
      SUPPORTED_SCOPES
    end

    def repo?
      test('repo')
    end

    def user?
      test('user:email')
    end

    def user_email?
      user? || test('user:email')
    end

    def org_read?
      org_admin? || test('read:org')
    end

    def org_admin?
      test('admin:org')
    end

    def org_hooks?
      test('admin:org_hook')
    end

    def to_s
      scope_list.join(',')
    end

    def with(new_scope)
      self.class.new(scope_list + [new_scope])
    end

    def -(other)
      self.scope_list - other.scope_list
    end

    def |(other)
      self.scope_list | other.scope_list
    end

    def &(other)
      self.scope_list & other.scope_list
    end

    private

    def test(value)
      value.in? @scope_list
    end
  end
end
