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
    unless control_code
      true
    else
      unless @parts.size > 3 and parts_valid?
        false
      else
        year_number + month + designer_number + count == control_code
      end
    end
  end

  def year
    @parts[0].upcase
  end

  def designer
    @parts[2].upcase
  end

  def month
    @parts[1] =~ /^\d+$/ && @parts[1].to_i || 0
  end

  def count
    @parts[3] =~ /^\d+$/ && @parts[3].to_i || 0
  end

  def control_code
    @parts[4] && @parts[4].to_i
  end

  def parts_valid?
    year_valid? and month_valid? and designer_valid? and count_valid?
  end

  def count_valid?
    count > 0
  end

  def month_valid?
    month > 0 and month <= 12
  end

  %w[designer year].each do |field|
    define_method "#{field}_number" do
      LETTERS.index(send(field)) + 1
    end
  end

  def year_valid?
    LETTERS.include?(year)
  end

  def designer_valid?
    if control_code
      LETTERS.include?(designer)
    else
      true
    end
  end
end