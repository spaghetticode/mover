require 'rubygems'
require File.dirname(__FILE__) + '/movable_file'
require File.dirname(__FILE__) + '/mover_helper'
require File.dirname(__FILE__) + '/app_config'

class Mover
  attr_reader :files, :source_dir, :target_dir, :second_target_dir
  
  def initialize(files, source_dir, target_dir, second_target_dir=nil)
    @files = files
    @source_dir = source_dir
    @target_dir = target_dir
    @second_target_dir = second_target_dir unless second_target_dir.blank?
    @moved_hash = {}
  end
  
  def mv
    recursive_mv(source_dir)
  end
  
  def not_moved
    files - @moved_hash.keys
  end
  
  def moved
    @moved_hash.values
  end
  
  private
  
  def recursive_mv(dir)
    dir.gsub!('\\', '/') # win fix
    Dir["#{dir}/*"].each do |entry|
      if File.file?(entry)
        basename_without_ext = File.basename(entry).chomp(File.extname(entry))
        if files.include?(basename_without_ext)
          file = MovableFile.new(entry, @target_dir, @second_target_dir)
          file.mv
          @moved_hash[basename_without_ext] = File.basename(entry)
        end
      else
        recursive_mv(entry) if File.directory?(entry)
      end
    end
  end
end