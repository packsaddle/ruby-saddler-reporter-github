module Saddler
  module Reporter
    module Github
      # Patches<Patch>
      #
      # @see https://github.com/packsaddle/ruby-git_diff_parser
      class Patches < GitDiffParser::Patches
      end
    end
  end
end
