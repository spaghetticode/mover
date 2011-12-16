class Code
  SEPARATOR = '-'
  
  def initialize(value)
    # value is a string with format A-01-C-123
    raise ArgumentError, 'code is not valid' unless value.split(SEPARATOR).size > 3
    @value = value
  end
  
  def clean
    @value.split('-')[0..3].join(SEPARATOR)
  end
end