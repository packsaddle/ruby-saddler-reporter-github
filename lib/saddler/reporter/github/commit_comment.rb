module Saddler
  module Reporter
    module Github
      class CommitComment
        include ::Saddler::Reporter::Support
        include Helper

        # https://developer.github.com/v3/repos/comments/#create-a-commit-comment
        def report(messages, options)
          repo_path = '.'
          repo = GitRepository.new(repo_path)

          sha = options['sha'] || repo.head.sha
          data = parse(messages)

          client = Client.new(repo)
          # fetch commit_comments
          commit_comments = client.commit_comments(sha)

          # build comment
          body = concat_body(data)
          return if body.empty?
          comment = Comment.new(sha, body, path = nil, position = nil)

          # compare commit_comments.include?(comment)
          return if commit_comments.include?(comment)
          # create commit_comment
          client.create_commit_comment(comment)
        end
      end
    end
  end
end
