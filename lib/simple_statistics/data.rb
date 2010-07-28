module SimpleStatistics
  class Data
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
    
    class DataProxy
      def initialize(receiver, id)
        @receiver = receiver
        @id = id
      end

      [:add_probe, :last_probes_by_count, :last_probes_by_time].each do |method|
        define_method method do |key, *args|
          @receiver.send(method, @id, key, *args)
        end
      end
    end

    attr_accessor :keep_probes
    
    def [](key)
      @probes ||= {}
      @probes[key.to_sym] ||= []
      DataProxy.new(self, key.to_sym)
    end

    def initialize(keep_probes = 20)
      @probes = {}
      @keep_probes = keep_probes
    end
    
    def add_probe(key, value)
      @probes ||= {}
      @probes[key.to_sym] ||= []
      @probes[key.to_sym] << [value, Time.now]
      if @keep_probes.to_i > 0 and @probes[key.to_sym].size > @keep_probes
        @probes[key.to_sym].shift
      end
    end
  
    def last_probes_by_count(key, num)
      result = @probes[key.to_sym][-num..-1] || []
      Sample.new(result.map { |p| p[0] })
    end
  
    def last_probes_by_time(key, time)
      result = []
      @probes[key.to_sym].reverse_each do |p|
        break if p[1] < time
        result.unshift(p[0]) 
      end
      Sample.new(result)
    end  
  end
end
