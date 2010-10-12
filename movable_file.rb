require 'rubygems'
require 'fileutils'

class MovableFile
  attr_reader :basename, :source_file, :target_file, :second_target_file
  
  def initialize(source_file, target, second_target=nil)
    @basename = File.basename(source_file)
    @source_file = source_file
    @target_file = File.join(target, basename)
    @second_target_file = File.join(second_target, basename) if second_target
  end
  
  def copied?
    if second_target_file
      File.file?(target_file) && File.file?(second_target_file)
    else
      File.file?(target_file)
    end
  end
  
  def copy
    FileUtils.cp(source_file, target_file)
    FileUtils.cp(source_file, second_target_file) if second_target_file
  end
  
  def rm
    FileUtils.rm(source_file)
  end
  
  def mv
    copy
    rm if copied?
  end
end