module Saddler
  module Reporter
    module Github
      class CommitComment
        def initialize(output)
          @output = output
        end

        # https://developer.github.com/v3/repos/comments/#create-a-commit-comment
        def report(messages, _options)

        end
      end
    end
  end
end
