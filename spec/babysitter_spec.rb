require_relative '../babysitter.rb'
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

    it "asks for additional input if it is not a valid format" do
      allow($stdin).to receive(:gets).and_return("5:00PM")
      expect { TimeClock.new("") }.to output("Please enter your time in the format HH:MM:AM/PM ex 5:00PM").to_stdout
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

    it "paid $8/hour from bedtime to midnight" do
      time_clock = TimeClock.new("10:00PM")
      time_clock.stop_time = "12:00AM"
      time_clock.bedtime = "11:00PM"
      expect(time_clock.total_pay).to eq(20)
    end

    it "paid $16/hour from midnight to end of job" do
      time_clock = TimeClock.new("10:00PM")
      time_clock.stop_time = "1:00AM"
      time_clock.bedtime = "11:00PM"
      expect(time_clock.total_pay).to eq(36)
    end

    describe "paid for full hours(no fractional hours).  Rounds fractional hours " do
      it "rounds 30 minutes up to one hour from start-time to bedtime" do
        time_clock = TimeClock.new("5:00PM")
        time_clock.stop_time = "6:30PM"
        time_clock.bedtime = "6:30PM"
        expect(time_clock.total_pay).to eq(24)
      end

      it "rounds 29 minutes down to zero hours from start-time to bedtime" do
        time_clock = TimeClock.new("5:00PM")
        time_clock.stop_time = "6:29PM"
        time_clock.bedtime = "6:29PM"
        expect(time_clock.total_pay).to eq(12)
      end

      it "rounds 30 minutes up to one hour from bedtime to midnight" do
        time_clock = TimeClock.new("10:00PM")
        time_clock.stop_time = "11:30PM"
        time_clock.bedtime = "10:00PM"
        expect(time_clock.total_pay).to eq(16)
      end

      it "rounds 29 minutes down to zero from bedtime to midnight" do
        time_clock = TimeClock.new("10:00PM")
        time_clock.stop_time = "11:29PM"
        time_clock.bedtime = "10:00PM"
        expect(time_clock.total_pay).to eq(8)
      end


      it "rounds 30 minutes up to one hour from midnight to end of job" do
        time_clock = TimeClock.new("10:00PM")
        time_clock.stop_time = "12:30AM"
        time_clock.bedtime = "11:00PM"
        expect(time_clock.total_pay).to eq(36)
      end

      it "rounds 29 minutes down to zero from midnight to end of job" do
        time_clock = TimeClock.new("10:00PM")
        time_clock.stop_time = "12:29AM"
        time_clock.bedtime = "11:00PM"
        expect(time_clock.total_pay).to eq(20)
      end

    end

  end
end