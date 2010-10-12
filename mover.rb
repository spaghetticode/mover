require 'rubygems'
require File.dirname(__FILE__) + '/movable_file'
require File.dirname(__FILE__) + '/mover_helper'

class Mover
  attr_reader :files, :source_dir, :target_dir, :second_target_dir, :moved
  
  def initialize(files, source_dir, target_dir, second_target_dir=nil)
    @files = files
    @source_dir = source_dir
    @target_dir = target_dir
    @second_target_dir = second_target_dir unless second_target_dir.blank?
    @moved = []
  end
  
  def mv
    recursive_mv(source_dir)
  end
  
  def not_moved
    files - moved
  end
  
  private
  
  def recursive_mv(dir)
    Dir["#{dir}/*"].each do |entry|
      if File.file?(entry)
        basename = File.basename(entry)
        if files.include?(basename)
          file = MovableFile.new(entry, @target_dir, @second_target_dir)
          file.mv
          moved << basename
        end
      elsif File.directory?(entry)
        recursive_mv(entry)
      end
    end
  end
end