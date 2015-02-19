module Saddler
  module Reporter
    module Github
      class CommitComment
        def initialize(output)
          @output = output
        end

        # https://developer.github.com/v3/repos/comments/#create-a-commit-comment
        def report(messages, options)
          sha1 = options[:sha1]
          data = parse(messages)

          comment = build_comment(data)

          # fetch commit_comments
          # compare commit_comments.include?(comment)
          # create commit_comment
        end

        def parse(xml)
          Nori
            .new(parser: :rexml)
            .parse(xml)
        end

        def build_comment(data)
          buffer = []
          files = data['checkstyle']['file'] ||= []
          files.each do |file|
            errors = file['error'] ||= []
            errors.each do |error|
              severity = error['@severity'] && error['@severity'].upcase
              message = error['@message']
              buffer << "#{severity}: #{message}"
            end
          end
          buffer.join("\n")
        end
      end
    end
  end
end
