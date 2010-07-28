require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe SimpleStatistics::DataSet do
  describe "searching" do
    before :each do
      @data_set = SimpleStatistics::DataSet.new
      10.times do |i|
        @now = Time.now
        {:process1 => 10, :process2 => 20, :process3 => 15}.each do |process, mem|
          Timecop.freeze(@now+i)
          @data_set[process][:private_mem].add_probe(mem)
          @data_set[process][:private_mem].add_probe(mem)
          @data_set[process][:private_mem].add_probe(mem)
        end
        Timecop.return
      end
    end

    it "should find correct values" do
      @result = []
      @data_set.where(:private_mem).mean.last_probes_by_count(10).is_higher_then(14) do |process|
        @result << process.to_sym
      end
      @result.should == [:process2, :process3]
    end
    
  end
end
