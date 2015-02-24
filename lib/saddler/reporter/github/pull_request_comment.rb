module Saddler
  module Reporter
    module Github
      class PullRequestComment
        include Support
        include Helper

        # https://developer.github.com/v3/issues/comments/#create-a-comment
        def report(messages, _options)
          repo_path = '.'
          repo = GitRepository.new(repo_path)

          data = parse(messages)

          client = Client.new(repo)
          # fetch pull_request_comments(issue)
          pull_request_comments = client.issue_comments

          # build comment
          body = concat_body(data)
          return if body.empty?
          comment = Comment.new(sha1 = nil, body, path = nil, position = nil)


          # compare pull_request_comments.include?(comment)
          return if pull_request_comments.include?(comment)
          # create pull_request_comment
          client.create_issue_comment(comment)
        end
      end
    end
  end
end
