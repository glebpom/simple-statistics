module SimpleStatistics
  class DataSet
    
    class DataFinder
      class DataFinderError < StandardError; end
      
      def initialize(probe, data_set)
        @probe = probe.to_sym
        @data_set = data_set
      end
      
      def is_higher_then(value, &block)
        @is_higher_then = value
        find(&block)
        self
      end
      
      def mean
        @aggregate = :mean
        self
      end
      
      def last_probes_by_count(count)
        @probes_count = count
        self
      end

      def last_probes_by_time(time)
        @probes_time = time
        self
      end
      
      def find(&block)
        @data_set.datas.each do |key, value|
          p = value[@probe]
          p = if @probes_count 
            p.last_probes_by_count(@probes_count)
          elsif @probes_time
            p.last_probes_by_time(@probes_time)
          else
            raise DataFinderError, "Sample is not defined. Use :last_probes_by_count or :last_probes_by_time"
          end
          if [:mean, :count, :sum].include?(@aggregate.to_sym)
            p = p.send(@aggregate)
          else
            raise DataFinderError, "Aggregate function is not define. User one of :mean, :count, :sum"
          end
          if @is_higher_then
            if p > @is_higher_then 
              block.call(key)
            end
          else
            raise DataFinderError, "Condition is not defined. Use :is_higher_then"
          end
        end
      end
    end
    
    def initialize
      @datas = {}
    end
    
    def where(probe)
      DataFinder.new(probe, self)
    end
    
    attr_reader :datas
    
    def [](key)
      @datas[key.to_sym] ||= Data.new
    end
  end
end