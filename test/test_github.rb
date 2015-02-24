require_relative 'helper'

module Saddler
  module Reporter
    module Github
      class TestGithub < Test::Unit::TestCase
        test 'version' do
          assert do
            !::Saddler::Reporter::Github::VERSION.nil?
          end
        end
      end
    end
  end
end
