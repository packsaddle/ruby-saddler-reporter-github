require 'minitest_helper'

class Saddler::Reporter::TestGithub < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Saddler::Reporter::Github::VERSION
  end

  def test_it_does_something_useful
    assert false
  end
end
