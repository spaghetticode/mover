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

class Array
  def join_in_groups_of(n)
    container = []
    each_slice(n) do |array|
      container << array.join(' ')
    end
    container.join("\n")
  end    
end
  
module FileAdapter
  SPLITTER =  "\n"
  
  def self.convert(files)
    filenames = files.split(SPLITTER)
    filenames.map {|f| "#{f}.jpg".strip}
  end
end