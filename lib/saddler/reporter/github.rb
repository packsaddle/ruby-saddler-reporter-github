require 'octokit'
require 'git_diff_parser'
require 'saddler/reporter/support'
require 'saddler/reporter/support/git'
require 'saddler/reporter/github/version'
require 'saddler/reporter/github/helper'
require 'saddler/reporter/github/client'
require 'saddler/reporter/github/comment'
require 'saddler/reporter/github/commit_comment'
require 'saddler/reporter/github/commit_review_comment'
require 'saddler/reporter/github/patch'
require 'saddler/reporter/github/patches'
require 'saddler/reporter/github/pull_request_comment'
require 'saddler/reporter/github/pull_request_review_comment'
require 'saddler/reporter/github/repository'

module Saddler
  module Reporter
    class ArgumentError < StandardError; end
    # Saddler reporter for GitHub.
    module Github
      class InvalidParameterError < ::Saddler::Reporter::ArgumentError; end
    end
  end
end
