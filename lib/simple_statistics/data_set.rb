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
      
      SimpleStatistics::AGGREGATE_FUNCTIONS.each do |aggregate|
        define_method aggregate do
          @aggregate = aggregate.to_sym
          self
        end
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
          if AGGREGATE_FUNCTIONS.include?(@aggregate.to_sym)
            p = p.send(@aggregate)
          else
            raise DataFinderError, "Aggregate function is not define. User one of :mean, :count, :sum"
          end
          if @is_higher_then
            if p.class.name == "Array"
              p.each do |p_aux| 
                block.call(key) if p_aux > @is_higher_then
              end
            elsif
              if p > @is_higher_then 
                block.call(key)
              end
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
    
    def tick(key)
      @datas.each do |k, data|
        data.tick(key)
      end
    end
    
    def add_data(key)
      self[key]
    end
    
    attr_reader :datas
    
    def [](key)
      @datas[key.to_sym] ||= Data.new
    end
  end
end
