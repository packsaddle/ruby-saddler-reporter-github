module Saddler
  module Reporter
    module Github
      class CommitComment
        include Support
        include Helper

        # https://developer.github.com/v3/repos/comments/#create-a-commit-comment
        def report(messages, options)
          sha1 = options['sha1']
          fail InvalidParameterError, 'required options[sha1]' unless sha1
          data = parse(messages)

          # build comment
          body = concat_body(data)
          return if body.empty?
          comment = Comment.new(sha1, body, nil, nil)

          repo_path = '.'
          repo = GitRepository.new(repo_path)
          client = Client.new(repo)
          # fetch commit_comments
          commit_comments = client.commit_comments(sha1)
          # compare commit_comments.include?(comment)
          return if commit_comments.include?(comment)
          # create commit_comment
          client.create_commit_comment(comment)
        end
      end
    end
  end
end
