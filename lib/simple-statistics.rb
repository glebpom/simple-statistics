module SimpleStatistics
  AGGREGATE_FUNCTIONS = [:mean, :max, :min, :count, :sum] 
end

require File.expand_path(File.join(File.dirname(__FILE__), '/simple_statistics/autoload'))

