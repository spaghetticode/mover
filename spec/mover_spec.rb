require File.dirname(__FILE__) + '/../mover.rb'

describe Mover do
  def basename_path
    File.dirname(__FILE__)
  end
  
  def prepare_fs
    @file = 'test.txt'
    @source_dir, @target_dir, @second_target_dir = "#{basename_path}/origin", "#{basename_path}/target", "#{basename_path}/second_target"
    system "touch #{@source_dir}/#{@file}" unless File.file?("#{@source_dir}/#{@file}")
  end
  
  def clear_fs
    [@target_dir, @second_target].each do |dir|
      unless dir.nil?
        system "rm #{dir}/*" unless Dir["#{dir}/*"].empty?
      end
    end
  end
  
  before do
    clear_fs
    prepare_fs
  end
  
  context 'a mover with both target directories set' do
    before { @mover = Mover.new([@file], @source_dir, @target_dir, @second_target_dir) }
    
    it 'should set attributes as expected' do
      @mover.files.should == [@file]
      @mover.source_dir.should == @source_dir
      @mover.target_dir.should == @target_dir
      @mover.second_target_dir.should == @second_target_dir 
    end
    
    it 'should set second_target_dir to nil' do
      @mover = Mover.new([@file], @source_dir, @target_dir, '')
      @mover.second_target_dir.should be_nil
    end
    
    it 'should create expected file' do
      @mover.mv
      File.file?(File.join(@target_dir, @file)).should be_true
      File.file?(File.join(@second_target_dir, @file)).should be_true
    end
  
    it 'moved should include expected file' do
      @mover.mv
      @mover.moved.should include(@file)
    end
  
    it 'not_moved should include expected file' do
      @mover.instance_variable_set('@file', @mover.files << 'not moved.txt')
      @mover.mv
      @mover.not_moved.should include('not moved.txt')
    end
  
    it 'should remove expected file' do
      @mover.mv
      File.file?(File.join(@source_dir, @file)).should be_false
    end
  end
  
  context 'a mover with only one target directory set' do
    before { @mover = Mover.new([@file], @source_dir, @target_dir) }
    
    it 'should create expected file' do
      @mover.mv
      File.file?(File.join(@target_dir, @file)).should be_true
    end
    
    it 'should remove expected file' do
      @mover.mv
      File.file?(File.join(@source_dir, @file)).should be_false
    end
  end
  
  context 'when files include a file in a nested dir' do
    before do
      @nested = 'sample.txt'
      nested_dir = 'down/nested'
      nested_dir_path = File.join(@source_dir, nested_dir)
      FileUtils.mkdir_p(nested_dir_path) unless File.directory?(nested_dir_path)
      @nested_file = File.join(@source_dir, nested_dir, @nested)
      system "touch #{@nested_file}"
      @mover = Mover.new([@file, @nested], @source_dir, @target_dir)
    end
    
    it 'should create expected file' do
      @mover.mv
      File.file?(File.join(@target_dir, @nested)).should be_true
    end
    
    it 'should remove source file' do
      @mover.mv
      File.file?(@nested_file).should be_false
    end
  end
end