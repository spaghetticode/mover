require 'rspec'
require File.dirname(__FILE__) + '/../mover'

Dir['*.rb'].each do |file|
  require file
end

Rspec::Matchers.define :be_a_file do
  match do |path|
    File.file?(path)
  end
  
  failure_message_for_should do |path|
    files = Dir["#{File.dirname(path)}/*"]
    files.map!{|f| f if File.file?(f)}.compact!
    "expected #{path} to be a file among #{files.join(', ')}"
  end
  
  failure_message_for_should_not do |path|
    files = Dir["#{File.dirname(path)}/*"]
    files.map!{|f| f if File.file?(f)}.compact!
    "expected #{path} not to be a file among #{files.join(', ')}"
  end
end