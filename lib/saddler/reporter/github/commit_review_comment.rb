require 'pathname'

module Saddler
  module Reporter
    module Github
      class CommitReviewComment
        include Support
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
          comments = build_comments(data, client, sha)
          return if comments.empty?

          posting_comments = comments - commit_comments
          return if posting_comments.empty?
          # create commit_comment
          client.create_commit_comment(posting_comments)
        end

        def build_comments(data, client, sha)
          patches = client.commit_patches(sha)
          comments = []
          files = data['checkstyle']['file'] ||= []
          files.each do |file|
            errors = file['error'] ||= []
            file_name = file['@name'] ||= ''
            patch = patches.find_patch_by_file(file_relative_path_string(file_name))
            next unless patch

            errors.each do |error|
              line_no = error['@line'] && error['@line'].to_i
              next unless patch.changed_line_numbers.include?(line_no)

              severity = error['@severity'] && error['@severity'].upcase
              message = error['@message']
              position = patch.changed_lines.detect { |line| line.number == line_no }.patch_position

              comments << Comment.new(sha, [severity, message].compact.join(': '), patch.file, position)
            end
          end
          comments
        end
      end
    end
  end
end
