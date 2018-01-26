require 'minitest/autorun'
require 'stringio'
require_relative 'babysitter.rb'


class BabysitterTest < Minitest::Test
  
  def test_has_start_time
    time_clock = TimeClock.new("5:00PM")
    assert_equal "5:00PM", time_clock.start_time
  end

end