require 'rspec'

require File.dirname(__FILE__) + '/../mover'

Dir['*.rb'].each do |file|
  require file
end
