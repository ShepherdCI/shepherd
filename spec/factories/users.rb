FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    sequence(:github_id) { |n| n }
    sequence(:github_login) { Faker::Internet.user_name }
    avatar_url { Faker::Internet.url('gravatar.com') }
  end
end
