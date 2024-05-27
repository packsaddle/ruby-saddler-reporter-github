module Saddler
  module Reporter
    module Github
      class PullRequestComment
        include ::Saddler::Reporter::Support
        include Helper

        # @param messages [String] checkstyle string
        # @param options [Hash]
        #
        # @return [void]
        #
        # @see https://developer.github.com/v3/issues/comments/#create-a-comment
        def report(messages, options)
          repo_path = '.'
          repo = Repository.new(repo_path)

          data = parse(messages)

          client = Client.new(repo, log_octokit: options['reporter-github-log_octokit'])
          # fetch pull_request_comments(issue)
          pull_request_comments = client.issue_comments

          # build comment
          body = concat_body(data)
          return if body.empty?

          sha = nil
          path = nil
          position = nil
          comment = Comment.new(sha, body, path, position)

          # compare pull_request_comments.include?(comment)
          return if pull_request_comments.include?(comment)
          # create pull_request_comment
          client.create_issue_comment(comment)
        end
      end
    end
  end
end
