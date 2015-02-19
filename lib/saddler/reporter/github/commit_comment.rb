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

          # build comment
          comment = build_comment(data)

          # fetch commit_comments
          # compare commit_comments.include?(comment)
          # create commit_comment
        end

        # {"checkstyle"=>
        #    {"file"=>
        #       [{"error"=>
        #           [{"@column"=>"4",
        #             "@line"=>"22",
        #             "@message"=>"Assignment Branch Condition size for report is too high. [34.34/15]",
        #             "@severity"=>"info",
        #             "@source"=>"com.puppycrawl.tools.checkstyle.Metrics/AbcSize"},
        #            {"@column"=>"4",
        #             "@line"=>"22",
        #             "@message"=>"Cyclomatic complexity for report is too high. [10/6]",
        #             "@severity"=>"info",
        #             "@source"=>"com.puppycrawl.tools.checkstyle.Metrics/CyclomaticComplexity"},
        #            {"@column"=>"6",
        #             "@line"=>"39",
        #             "@message"=>"Use space after control keywords.",
        #             "@severity"=>"info",
        #             "@source"=>"com.puppycrawl.tools.checkstyle.Style/SpaceAfterControlKeyword"}],
        #         "@name"=>"/Users/sane/work/ruby-study/saddler/lib/saddler/cli.rb"},
        #        {"@name"=>"/Users/sane/work/ruby-study/saddler/lib/saddler/reporter.rb"}]}}
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
              buffer << [severity, message].compact.join(': ')
            end
          end
          buffer.join("\n")
        end
      end
    end
  end
end
