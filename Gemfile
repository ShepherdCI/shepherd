source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.4'
gem 'puma', '~> 3.7'
gem 'pg'
gem 'redis'
gem 'sidekiq'

gem "faraday"
gem "octokit"
gem 'virtus'
gem 'graphql-client'

gem 'pry'

gem 'devise'
gem 'omniauth-github'
gem 'jwt'

gem 'webpacker'

gem 'jsonapi-serializable'
gem 'jsonapi_suite', '~> 0.6'
gem 'jsonapi-rails', '~> 0.2.1'
gem 'jsonapi_swagger_helpers', '~> 0.6', require: false
gem 'jsonapi_spec_helpers', '~> 0.4', require: false
gem 'kaminari', '~> 1.0'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 3.5.2'
  gem 'factory_bot_rails', '~> 4.0'
  gem 'faker', '~> 1.7'
  gem 'swagger-diff', '~> 1.1'
  gem 'dotenv-rails'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'

  gem 'guard', require: false
  gem 'guard-rspec'
  gem 'terminal-notifier-guard', require: false
  gem 'terminal-notifier', require: false
end

group :test do
  gem 'database_cleaner', '~> 1.6'
  gem 'timecop'
end
