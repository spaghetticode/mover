require 'rubygems'
require File.expand_path('../movable_file', __FILE__)
require File.expand_path('../helpers', __FILE__)
require File.expand_path('../app_config', __FILE__)

class Mover
  attr_reader :files, :source_dir, :target_dir, :second_target_dir, :moved_count

  def initialize(prog_bar, files, source_dir, target_dir, second_target_dir=nil)
    @files      = files
    @prog_bar   = prog_bar
    @source_dir = source_dir
    @target_dir = target_dir
    @second_target_dir = second_target_dir unless second_target_dir.blank?
    @moved_hash  = {}
    @moved_count = 0
    @files_count = files.size
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

  def remaining_count
    @files_count - @moved_count
  end

  def progress_count
    ((100.0 / @files_count) * @moved_count).to_i
  end

  def recursive_mv(dir)
    dir.gsub!('\\', '/') if FileAdapter.mswindows?
    Dir["#{dir}/*"].each do |entry|
      if File.file?(entry)
        basename_without_ext = File.basename(entry).chomp(File.extname(entry))
        if files.include?(basename_without_ext)
          file = MovableFile.new(entry, @target_dir, @second_target_dir)
          if file.mv && @moved_hash[basename_without_ext].nil?
            @moved_hash[basename_without_ext] = File.basename(entry)
            @moved_count += 1
            if @moved_count % 5 == 0
              @prog_bar.update(progress_count, "#{@moved_count} files spostati, #{remaining_count} files ancora da spostare")
            end
          end
        end
      else
        recursive_mv(entry) if File.directory?(entry)
      end
    end
  end
end