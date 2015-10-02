module Saddler
  module Reporter
    module Github
      class CommitComment
        include ::Saddler::Reporter::Support
        include Helper

        # @param messages [String] checkstyle string
        # @param options [Hash]
        # @option options [String] sha target commit sha
        #
        # @return [void]
        #
        # @see https://developer.github.com/v3/repos/comments/#create-a-commit-comment
        def report(messages, options)
          repo_path = '.'
          repo = Repository.new(repo_path)

          sha = options['sha'] || repo.head.sha
          data = parse(messages)

          client = Client.new(repo)
          # fetch commit_comments
          commit_comments = client.commit_comments(sha)

          # build comment
          body = concat_body(data)
          return if body.empty?

          path = nil
          position = nil
          comment = Comment.new(sha, body, path, position)

          # compare commit_comments.include?(comment)
          return if commit_comments.include?(comment)
          # create commit_comment
          client.create_commit_comment(comment)
        end
      end
    end
  end
end
