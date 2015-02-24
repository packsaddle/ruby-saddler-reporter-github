require 'pathname'

module Saddler
  module Reporter
    module Github
      class CommitReviewComment
        include ::Saddler::Reporter::Support
        include Helper

        # https://developer.github.com/v3/repos/comments/#create-a-commit-comment
        def report(messages, options)
          repo_path = '.'
          repo = ::Saddler::Reporter::Support::Git::Repository.new(repo_path)

          sha = options['sha'] || repo.head.sha
          data = parse(messages)

          client = Client.new(repo)
          # fetch commit_comments
          commit_comments = client.commit_comments(sha)

          patches = client.commit_patches(sha)
          # build comment
          comments = build_comments_with_patches(data, patches)
          return if comments.empty?

          posting_comments = comments - commit_comments
          return if posting_comments.empty?
          # create commit_comment
          posting_comments.each do |posting|
            client.create_commit_comment(posting)
          end
        end
      end
    end
  end
end
