module GithubService
  class MissingAccessTokenError < StandardError; end
  extend ActiveSupport::Concern

  include Virtus.module

  attribute :access_token, String
  attribute :github_client, Octokit::Client, default: (lambda do |page, attr|

    unless page.access_token
      raise MissingAccessTokenError, 'You must provide an access token'
    end

    Octokit::Client.new(access_token: page.access_token, auto_paginate: true)
  end)

  def github_action_name
    self.class.name.split('::').last.underscore
  end

  def github_resource
    nil
  end

  def around_call
    call
  rescue Octokit::Forbidden
    GithubAuthorizationError.new(github_action_name, resource: github_resource)
  end
end
