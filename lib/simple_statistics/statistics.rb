module SimpleStatistics
  class Statistics
    class Sample
      attr_reader :data
      
      def initialize(data)
        @data = data
      end
    
      def full?
        not data.any? { |s| s.nil? }
      end
    
      def mean
        sum.to_f/count
      end
    
      def count
        @data.compact.size
      end
    
      def sum
        @data.compact.inject(0) { |r,v| r=r+v }
      end
    end

    attr_accessor :keep_probes
  
    def initialize
      @probes = []
      @keep_probes = 0
    end
  
    def add_probe(value)
      @probes << [value, Time.now]
      if @keep_probes.to_i > 0 and @probes.size > @keep_probes
        @probes.shift
      end
    end
  
    def last_probes_by_count(num)
      Sample.new(@probes[-num..-1].map { |p| p[0] })
    end
  
    def last_probes_by_time(time)
      result = []
      @probes.reverse_each do |p|
        break if p[1] < time
        result.unshift(p[0]) 
      end
      Sample.new(result)
    end  
  end
end
