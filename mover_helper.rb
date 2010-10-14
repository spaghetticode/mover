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
  
  def self.convert(files)
    files.split(SPLITTER).map {|filename| filename.strip}.compact.uniq
  end
end