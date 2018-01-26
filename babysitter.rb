class TimeClock
  attr_reader :start_time
  attr_accessor :stop_time
  
  def initialize(start_time)
    @start_time = start_time
  end
end

class BabysitterCLI
  def self.run
    print "Please enter your start time (ex. 5:00PM)"
    time_clock = TimeClock.new(gets.chomp)
    print "Please enter your stop time"
    time_clock.stop_time = gets.chomp
  end
end