require 'pathname'

module Saddler
  module Reporter
    module Github
      class CommitReviewComment
        include Support
        include Helper

        # copy from checkstyle_filter-git
        def self.file_in_patches?(file_name, patches)
          patches
            .map(&:file)
            .map { |file| Pathname.new(file).expand_path }
            .include?(Pathname.new(file_name).expand_path)
        end

        # copy from checkstyle_filter-git
        def self.file_element_error_line_no_in_patches?(file_name, patches, line_no)
          diff_patches = patches
                         .select { |patch| same_file?(patch.file, file_name) }
          return false if diff_patches.empty?

          modified_lines = Set.new
          diff_patches.map do |patch|
            patch.changed_lines.map do |line|
              modified_lines << line.number
            end
          end

          modified_lines.include?(line_no)
        end

        # copy from checkstyle_filter-git
        def self.same_file?(one, other)
          Pathname.new(one).expand_path == Pathname.new(other).expand_path
        end

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
            diff_patch = patches.detect { |patch| self.class.same_file?(patch.file, file_name) }
            next unless self.class.file_in_patches?(file_name, patches)
            errors.each do |error|
              line_no = error['@line'] && error['@line'].to_i
              next unless self.class.file_element_error_line_no_in_patches?(file_name, patches, line_no)

              severity = error['@severity'] && error['@severity'].upcase
              message = error['@message']
              position = diff_patch.changed_lines.detect { |line| line.number == line_no }.patch_position

              comments << Comment.new(sha, [severity, message].compact.join(': '), diff_patch.file, position)
            end
          end
          comments
        end
      end
    end
  end
end
