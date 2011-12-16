class Validator
  def initialize(codes)
    @codes = codes.map { |code| Code.new(code) }
    @invalid = []
  end
  
  def get_invalid_codes
    validate
    invalid_codes
  end
  
  def validate
    @codes.inject(@invalid) do |invalid, code|
      invalid << code unless code.valid?
      invalid
    end
  end
  
  def invalid_codes
    @invalid.map { |code| code.value }.join(' ')
  end
end