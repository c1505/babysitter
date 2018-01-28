require_relative '../babysitter.rb'
require 'pry'
RSpec.describe TimeClock do
  
  describe "#start_time" do
    
    it "has a start time" do
      time_clock = TimeClock.new("5:00PM")
      expect(time_clock.start_time).to eq("5:00PM")
    end
    
    it "does not start earlier than 5:00PM" do
      allow($stdin).to receive(:gets).and_return("5:00PM")
      expect { TimeClock.new("4:59PM") }.to output("Your start time cannot be prior to 5:00PM.  Please enter a different time").to_stdout
    end
    
    it "exits program if there is a repeated start time that is too early" do
      allow($stdin).to receive(:gets).and_return("4:59PM", "4:59PM")
      expect { TimeClock.new("4:59PM") }.to output(/Your start time cannot be prior to 5:00PM. Exiting the program/).to_stdout
    end
  end
  
  describe "#stop_time" do 
    it "has a stop time" do
      time_clock = TimeClock.new("5:00PM")
      allow($stdin).to receive(:gets).and_return("")
      time_clock.stop_time = "8:00PM"
      expect(time_clock.stop_time).to eq("8:00PM")
    end
    
    it "ends no later than 4:00AM" do
      time_clock = TimeClock.new("5:00PM")
      allow($stdin).to receive(:gets).and_return("3:00AM")
      expect { time_clock.stop_time = "4:01AM" }.to output("Your end time cannot be after 4:00AM.  Please enter a different time\n").to_stdout
    end
    
    it "exits program if there is a repeated stop time that is too late" do
      time_clock = TimeClock.new("5:00PM")
      allow($stdin).to receive(:gets).and_return("4:01AM", "4:01AM")
      expect { time_clock.stop_time = "4:01AM" }.to output(/Your end time cannot be after 4:00AM. Exiting the program/).to_stdout
    end
  end
  
  describe "#total_pay" do
    it "paid $12/hour from start-time to bedtime" do
      time_clock = TimeClock.new("5:00PM")
      time_clock.stop_time = "6:00PM"
      time_clock.bedtime = "6:00PM"
      expect(time_clock.total_pay).to eq(12)
    end
  end
end