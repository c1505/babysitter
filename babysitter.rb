class TimeClock
  attr_reader :start_time
  attr_writer :stop_time
  
  def initialize(start_time)
    @start_time = start_time
  end
end

class BabysitterCLI
  def self.run
    print "Please enter your start time (ex. 5:00PM)"
    time_clock = TimeClock.new(gets.chomp)
  end

end