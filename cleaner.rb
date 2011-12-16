class Cleaner
  def initialize(codes)
    @codes = codes.map {|code| Code.new(code)}
  end
  
  def remove_control_codes
    @codes.map do |code|
      code.clean
    end.join(' ')
  end
end