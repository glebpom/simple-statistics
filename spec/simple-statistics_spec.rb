require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe SimpleStatistics::Statistics do
  describe "collection" do
    before :each do
      @statistics = SimpleStatistics::Statistics.new
    end
    
    it "should accept probes with #add_probe" do
      lambda {
        @statistics.add_probe(1)
      }.should_not raise_error
    end
    
    describe "with some probes" do
      before :each do
        @now = Time.now
        100.times do |i|
          Timecop.freeze(@now+i)
          @statistics.add_probe(i)
        end
        Timecop.return
      end
      
      describe "on call #last_probes_by_count with 3 probes" do
        before :each do
          @sample = @statistics.last_probes_by_count(3)
        end
        
        it "should return Sample with correct data" do
          @sample.data.should == [97,98,99]
        end
      end

      describe "on call #last_probes_by_time with Time.now - 10.seconds probes" do
        before :each do
          @sample = @statistics.last_probes_by_time(@now + 100 - 10)
        end
        
        it "should return Sample with correct data" do
          @sample.data.should == [90,91,92,93,94,95,96,97,98,99]
        end
      end

    end
  end
end
