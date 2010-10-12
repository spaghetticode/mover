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
    filenames = files.split(SPLITTER)
    filenames.map {|f| "#{f}.jpg".strip}
  end
end