module Saddler
  module Reporter
    module Github
      class CommitComment
        def initialize(output)
          @output = output
        end

        # https://developer.github.com/v3/repos/comments/#create-a-commit-comment
        def report(messages, _options)
          # build comment
          # fetch commit_comments
          # compare commit_comments.include?(comment)
          # create commit_comment
        end
      end
    end
  end
end
