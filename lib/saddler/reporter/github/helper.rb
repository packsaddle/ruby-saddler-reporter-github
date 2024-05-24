module Saddler
  module Reporter
    module Github
      # Helper for saddler-reporter-github
      module Helper
        # Concatenate parsed errors
        #
        # @param data [Object] parsed checkstyle data
        #
        # @return [String] concatenated errors. separated with new line.
        def concat_body(data)
          buffer = []
          files = data.dig('checkstyle', 'file') || []
          files = [files] if files.is_a?(Hash)
          files.each do |file|
            errors = file['error'] ||= []
            errors = [file['error']] if errors.is_a?(Hash)
            errors.each do |error|
              severity = error['@severity'] && error['@severity'].upcase
              message = error['@message']
              buffer << [severity, message].compact.join(': ')
            end
          end
          buffer.join("\n")
        end

        # Build comment objects by parsed errors and patches
        #
        # @param data [Object] parsed checkstyle data
        # @param patches [Patches<Patch>] `git diff`'s patch section
        #
        # @return [Array<Comment>] comment objects
        def build_comments_with_patches(data, patches)
          comments = []
          files = data.dig('checkstyle', 'file') || []
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
