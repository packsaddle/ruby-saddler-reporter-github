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

          patches = client.commit_patches(sha)
          # build comment
          comments = build_comments(data, patches)
          return if comments.empty?

          posting_comments = comments - commit_comments
          return if posting_comments.empty?
          # create commit_comment
          posting_comments.each do |posting|
            client.create_commit_comment(posting)
          end
        end

        def build_comments(data, patches)
          comments = []
          files = data['checkstyle']['file'] ||= []
          files = [files] if files.is_a?(Hash)
          files.each do |file|
            errors = file['error'] ||= []
            errors = [file['error']] if errors.is_a?(Hash)
            file_name = file['@name'] ||= ''
            patch = patches.find_patch_by_file(file_relative_path_string(file_name))
            next unless patch

            errors.each do |error|
              line_no = error['@line'] && error['@line'].to_i
              next unless patch.changed_line_numbers.include?(line_no)

              severity = error['@severity'] && error['@severity'].upcase
              message = error['@message']
              position = patch.find_patch_position_by_line_number(line_no)

              comments << Comment.new(patch.secure_hash, [severity, message].compact.join(': '), patch.file, position)
            end
          end
          comments
        end
      end
    end
  end
end
