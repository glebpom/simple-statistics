module SimpleStatistics
  class Data
    class Sample
      attr_reader :data
      
      def initialize(data)
        @data = data
      end
    
      def full?
        not @data.any? { |s| s.nil? }
      end
    
      def mean
        sum.to_f/count
      end
      
      def max
        @data.max
      end
      
      def min
        @data.min
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
      @probes[key.to_sym] ||= {}
      DataProxy.new(self, key.to_sym)
    end
    
    def tick(key)
      current_time = Time.now
      @current_tick[key.to_sym] = current_time
      @probes[key.to_sym] ||= {}
      @probes[key.to_sym][current_time] = nil
    end

    def initialize(keep_probes = 20)
      @probes = {}
      @keep_probes = keep_probes
      @current_tick = {}
    end
    
    def add_probe(key, value)
      @probes ||= {}
      @probes[key.to_sym] ||= {}
      if !@current_tick || !@current_tick[key.to_sym]
        raise "You should call #tick first"
      end
      @probes[key.to_sym][@current_tick[key.to_sym]] = value
      if @keep_probes.to_i > 0 and @probes[key.to_sym].size > @keep_probes
        min = @probes[key.to_sym].keys.min
        @probes[key.to_sym].delete_if { |k,v| k ==  min }
      end
    end
  
    def reset(key)
      @probes ||= {}
      @probes[key.to_sym] = {}
    end  
  
    def last_probes_by_count(key, num)
      result = @probes[key.to_sym].to_a.sort_by { |k| k[0] }.map{|k| k[1]}[-num..-1] || []
      Sample.new(result)
    end
  
    def last_probes_by_time(key, time)
      result = @probes[key.to_sym].to_a.sort_by { |k| k[0] }.reject{|k| k[0] < time}.map { |k| k[1]} || []
      Sample.new(result)
    end  
  end
end
