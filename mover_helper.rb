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

class FileAdapter
end