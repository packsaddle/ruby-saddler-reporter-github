module Saddler
  module Reporter
    module Github
      class CommitReviewComment
        def initialize(output)
          @output = output
        end

        # https://developer.github.com/v3/repos/comments/#create-a-commit-comment
        def report(_messages, _options)
        end
      end
    end
  end
end
