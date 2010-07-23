module SimpleStatistics
  # @private
  def self.__p(*path) File.join(File.dirname(File.expand_path(__FILE__)), *path) end

  autoload :Statistics,         __p('statistics')
  
end