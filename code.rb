class Code
  SEPARATOR = '-'
  LETTERS = ('A'..'Z').to_a
  
  # value is a string with format A-01-C-123
  attr_accessor :value
  
  def initialize(value)
    @value = value
    @parts = value.split(SEPARATOR)
  end
  
  def clean
    @parts[0..3].join(SEPARATOR)
  end
  
  def valid?
    return true unless control_code
    return false unless @parts.size > 3
    year_number + month + designer_number + count == control_code
  end
  
  def year_number
    LETTERS.index(@parts[0].upcase) + 1
  end
  
  def month
    @parts[1].to_i
  end
  
  def designer_number
    LETTERS.index(@parts[2].upcase) + 1
  end
  
  def count
    @parts[3].to_i
  end
  
  def control_code
    @parts[4] && @parts[4].to_i
  end
end