class CreateMembership
  include CallableService

  attribute :user
  attribute :target
  attribute :admin

  def call
    if membership = Membership.find_by(object: target, user: user)
      membership.update_attributes(attrs)
    else
      membership = Membership.create!(attrs)
    end

    membership
  end

  private
  def attrs
    attrs = {
      user: user,
      object: target,
    }

    unless admin.nil?
      attrs[:admin] = admin
    end

    attrs
  end
end
