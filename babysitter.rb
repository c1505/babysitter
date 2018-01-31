require 'time'
require 'pry'
class TimeClock
  attr_reader :start_time
  attr_reader :stop_time
  attr_accessor :bedtime
  
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
  
  def total_pay
    pay_before_bed + pay_after_bed_before_midnight + pay_after_midnight
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
  
  def pay_before_bed
    hours_worked = ( Time.parse(bedtime) - Time.parse(start_time) ) / 60 / 60
    hours_worked.round * 12
  end
  
  def pay_after_bed_before_midnight
    if Time.parse(stop_time).hour <= 4
      time = Time.parse("12:00AM") + day_in_seconds
    else
      time = Time.parse(stop_time)
    end
    hours_worked = ( time - Time.parse(bedtime) ) / 60 / 60
    hours_worked.round * 8
  end
  
  def pay_after_midnight
    if Time.parse(stop_time).hour <= 4
      midnight = Time.parse("12:00AM")
      hours_worked = ( Time.parse(stop_time) - midnight ) / 60 / 60
      hours_worked.round * 16
    else
      0
    end
  end
  
  def day_in_seconds
    24 * 60 * 60
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
    print "Please enter the bedtime"
    time_clock.bedtime = get_input
    puts "Your total pay is $#{time_clock.total_pay}"
  end
end