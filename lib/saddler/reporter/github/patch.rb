module Saddler
  module Reporter
    module Github
      # Patch
      #
      # @see https://github.com/packsaddle/ruby-git_diff_parser
      class Patch < GitDiffParser::Patch
      end
    end
  end
end
