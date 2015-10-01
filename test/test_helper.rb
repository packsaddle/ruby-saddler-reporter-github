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
        one_file_no_error = {
          'checkstyle' => {
            'file' => {
              '@name' => '/home/travis/build/jser/jser.github.io/_i18n/ja/_posts/2015/2015-09-16-react-0.14-eslint-1.4-es5.md'
            },
            '@version' => '4.3'
          }
        }

        two_files_multi_errors = {
          'checkstyle' => {
            'file' => [
              {
                'error' => {
                  '@line' => '3',
                  '@column' => '100',
                  '@severity' => 'info',
                  '@message' => 'Line is too long. [187/100]',
                  '@source' => 'com.puppycrawl.tools.checkstyle.Metrics/LineLength'
                },
                '@name' => 'example/invalid.rb'
              },
              {
                'error' => [
                  {
                    '@line' => '14',
                    '@column' => '6',
                    '@severity' => 'info',
                    '@message' => 'Assignment Branch Condition size for diff is too high. [38.21/15]',
                    '@source' => 'com.puppycrawl.tools.checkstyle.Metrics/AbcSize'
                  },
                  {
                    '@line' => '14',
                    '@column' => '6',
                    '@severity' => 'info',
                    '@message' => 'Cyclomatic complexity for diff is too high. [9/6]',
                    '@source' => 'com.puppycrawl.tools.checkstyle.Metrics/CyclomaticComplexity'
                  },
                  {
                    '@line' => '14',
                    '@column' => '6',
                    '@severity' => 'info',
                    '@message' => 'Method has too many lines. [26/10]',
                    '@source' => 'com.puppycrawl.tools.checkstyle.Metrics/MethodLength'
                  },
                  {
                    '@line' => '14',
                    '@column' => '6',
                    '@severity' => 'info',
                    '@message' => 'Perceived complexity for diff is too high. [10/7]',
                    '@source' => 'com.puppycrawl.tools.checkstyle.Metrics/PerceivedComplexity'
                  },
                  {
                    '@line' => '65',
                    '@column' => '8',
                    '@severity' => 'info',
                    '@message' => 'Assignment Branch Condition size for file_element_error_line_no_in_modified? is too high. [16.16/15]',
                    '@source' => 'com.puppycrawl.tools.checkstyle.Metrics/AbcSize'
                  },
                  {
                    '@line' => '65',
                    '@column' => '8',
                    '@severity' => 'info',
                    '@message' => 'Method has too many lines. [14/10]',
                    '@source' => 'com.puppycrawl.tools.checkstyle.Metrics/MethodLength'
                  }
                ],
                '@name' => 'lib/checkstyle_filter/git/cli.rb'
              }
            ]
          }
        }

        sub_test_case '#concat_body' do
          test 'one file one error' do
            expected = 'INFO: Line is too long. [164/120]'
            assert do
              target.concat_body(one_file_one_error) == expected
            end
          end
          test 'one file no error' do
            expected = ''
            assert do
              target.concat_body(one_file_no_error) == expected
            end
          end
          test 'two files multi errors' do
            expected = <<-EXPECTED
INFO: Line is too long. [187/100]
INFO: Assignment Branch Condition size for diff is too high. [38.21/15]
INFO: Cyclomatic complexity for diff is too high. [9/6]
INFO: Method has too many lines. [26/10]
INFO: Perceived complexity for diff is too high. [10/7]
INFO: Assignment Branch Condition size for file_element_error_line_no_in_modified? is too high. [16.16/15]
INFO: Method has too many lines. [14/10]
            EXPECTED
            expected.chomp!
            assert do
              target.concat_body(two_files_multi_errors) == expected
            end
          end
        end
      end
    end
  end
end
