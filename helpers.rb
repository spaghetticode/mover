class String
  def blank?
    gsub(/\s+/, '').empty?
  end
end

class NilClass
  def blank?
    true
  end
end
  
module FileAdapter
  SPLITTER =  "\n"
  
  class << self
    def convert(files)
      files.split(SPLITTER).map {|filename| filename.strip}.compact.uniq
    end
  
    def codes(values)
      values.split(' ').map {|code| code.strip}.compact.uniq
    end
  end
end