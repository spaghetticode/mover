class Cleaner
  NEW_LINE = "\n" # use windows newlines

  def initialize(codes)
    @codes = codes.map {|code| Code.new(code)}
  end

  def remove_control_codes
    @codes.map do |code|
      code.clean
    end.join(NEW_LINE)
  end
end