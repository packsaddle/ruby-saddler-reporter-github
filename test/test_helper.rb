require_relative 'helper'

module Saddler
  module Reporter
    module Github
      class TestHelper < Test::Unit::TestCase
        target = Class.new do
          include Helper
        end.new

        one_file_one_error = {
          'checkstyle' => {
            'file' => {
              'error' => {
                '@column' => '120',
                '@line' => '7',
                '@message' => 'Line is too long. [164/120]',
                '@severity' => 'info',
                '@source' => 'com.puppycrawl.tools.checkstyle.Metrics/LineLength'
              },
              '@name' => 'lib/example/travis_ci.rb'
            }
          }
        }

        sub_test_case '#concat_body' do
          test 'one file one error' do
            expected = 'INFO: Line is too long. [164/120]'
            assert do
              target.concat_body(one_file_one_error) == expected
            end
          end
        end
      end
    end
  end
end
