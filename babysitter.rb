require 'time'
require 'pry'
class TimeClock
  attr_reader :start_time
  attr_reader :stop_time
  
  def initialize(start_time, cli=BabysitterCLI.new)
    @cli = cli
    @start_time = start_time
    @start_counter = 1
    if before_valid_start_time? && @start_counter <=2
      get_start_time
    end
  end
  
  def stop_time=(stop_time)
    @stop_counter ||= 1
    @stop_time = stop_time
    if after_valid_stop_time?
      get_stop_time
    end
  end
  
  def get_start_time
    print "Your start time cannot be prior to 5:00PM.  Please enter a different time"
    @start_time = @cli.get_input
    if before_valid_start_time? && @start_counter <=2
      @start_counter += 1
      get_start_time
    elsif before_valid_start_time?
      puts "Your start time cannot be prior to 5:00PM. Exiting the program"
    end
  end
  
  def get_stop_time
    puts "Your end time cannot be after 4:00AM.  Please enter a different time"
    @stop_time = @cli.get_input
    if after_valid_stop_time? && @stop_counter <=2
      @stop_counter += 1
      get_stop_time
    elsif after_valid_stop_time?
      puts "Your end time cannot be after 4:00AM. Exiting the program"
    end
  end
  
  private
  
  def before_valid_start_time?
    Time.parse(start_time) < Time.parse("5:00PM")
  end
  
  def after_valid_stop_time?
    if Time.parse(stop_time).hour <= 4
      Time.parse(stop_time) > Time.parse("4:00AM")
    elsif Time.parse(stop_time).hour > 4
      Time.parse(stop_time) < Time.parse(start_time)
    end
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