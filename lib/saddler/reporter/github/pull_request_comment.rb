module Saddler
  module Reporter
    module Github
      class PullRequestComment
        def initialize(output)
          @output = output
        end

        # https://developer.github.com/v3/issues/comments/#create-a-comment
        def report(_messages, _options)
        end
      end
    end
  end
end
