$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'simple-statistics'
require 'rspec'
require 'rubygems'
require 'timecop'
require 'rspec/autorun'

Spec::Runner.configure do |config|
  
end
