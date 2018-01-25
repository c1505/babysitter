require 'minitest/autorun'
require_relative 'babysitter.rb'

class BabysitterTest < Minitest::Test
  def test_prompt_for_start_time
    assert_output("Please enter your start time") { BabysitterCLI.run }
  end
end