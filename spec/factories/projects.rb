FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "#{owner.github_login}/repo#{n}" }
    sequence(:github_id) { |n| n }
    owner factory: :user
  end
end
