class TimeClock
  attr_reader :start_time
  attr_accessor :stop_time
  
  def initialize(start_time, cli=BabysitterCLI.new)
    @cli = cli
    @start_time = start_time
    unless valid_start_time?
      get_start_time
    end
  end
  
  def get_start_time
    print "Your start time cannot be prior to 5:00PM.  Please enter a different time"
    @start_time = @cli.get_input
  end
  
  def valid_start_time?
    Time.new(start_time) >= Time.new("5:00PM")
  end
end

class BabysitterCLI
  def get_input
    $stdin.gets.chomp
  end
  
  def run
    print "Please enter your start time (ex. 5:00PM)"
    time_clock = TimeClock.new(get_input, self)
    print "Please enter your stop time"
    time_clock.stop_time = get_input
  end
end