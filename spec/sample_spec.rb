require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe SimpleStatistics::Data::Sample do
  before :each do
    @statistics = SimpleStatistics::Data.new
    @now = Time.now
    1.upto(3) do |i|
      Timecop.freeze(@now+i)
      @statistics[:default].add_probe(i)
    end
    Timecop.return
    @sample = @statistics[:default].last_probes_by_count(3)
  end
  
  it "should respond with correct data on call #mean" do
    @sample.mean.should == 2
  end

  it "should respond with correct data on call #count" do
    @sample.count.should == 3
  end
  
  it "should respond with correct data on call #sum" do
    @sample.sum.should == 6
  end
  
  describe "have nil values" do
    before :each do
      Timecop.freeze(@now+4)
      @statistics[:default].add_probe(nil)
      @sample = @statistics[:default].last_probes_by_count(3)
    end
    
    it "should not be full" do
      @sample.should_not be_full
    end
  end
end
