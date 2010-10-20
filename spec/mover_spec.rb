describe Mover do
  def basename_path
    File.dirname(__FILE__)
  end
  
  def prog_bar
    @prog_bar ||= mock
  end
  
  def prepare_fs
    @file_path = File.join(@source_dir, @file)
    @not_moved_file_path = File.join(@source_dir, @not_moved_file)
    @nested_file_path = File.join(@source_dir, 'nested/down', @nested_file)
    # creo i file:
    [@file_path, @not_moved_file_path, @nested_file_path].each do |file|
      FileUtils.touch file
      File.file?(file).should be_true
    end
  end
  
  before do
    @file = 'test.txt'
    @not_moved_file = 'not_moved.pdf'
    @file_without_ext = @file.chomp(File.extname(@file))
    @nested_file = 'nested.jpg'
    @nested_file_without_ext = @nested_file.chomp(File.extname(@nested_file))
    @source_dir, @target_dir, @second_target_dir = "#{basename_path}/origin", "#{basename_path}/target", "#{basename_path}/second_target"
    prepare_fs
  end
  
  after do
    [@target_dir, @second_target_dir].each do |dir|
      [@file, @not_moved_file, @nested_file].each do |file|
        path = File.join(dir, file)
        FileUtils.rm(path) if File.file?(path)
      end
    end
  end
  
  context 'a mover with both target directories set' do
    before { @mover = Mover.new(prog_bar, [@file_without_ext], @source_dir, @target_dir, @second_target_dir) }
    
    it 'should set attributes as expected' do
      @mover.files.should == [@file.chomp(File.extname(@file))]
      @mover.source_dir.should == @source_dir
      @mover.target_dir.should == @target_dir
      @mover.second_target_dir.should == @second_target_dir 
    end
    
    it 'should set second_target_dir to nil' do
      @mover = Mover.new(prog_bar, [@file], @source_dir, @target_dir, '')
      @mover.second_target_dir.should be_nil
    end
    
    it 'should create expected file' do
      @mover.mv
      (File.join(@target_dir, @file)).should be_a_file
      (File.join(@second_target_dir, @file)).should be_a_file
    end
    
    it 'shoould not remove files that should not be moved' do
      @mover.mv
      @not_moved_file_path.should be_a_file
    end
    
    it 'moved should include expected file' do
      @mover.mv
      @mover.moved.should include(@file)
    end
    
    it 'moved should not include file not to be moved' do
      @mover.mv
      @mover.moved.should_not include(@not_moved_file)
    end
    
    it 'not_moved should include expected file' do
      @mover.instance_variable_set('@file', @mover.files << 'unexisting')
      @mover.mv
      @mover.not_moved.should include('unexisting')
    end
    
    it 'not_moved should include only one item' do
      @mover.instance_variable_set('@file', @mover.files << 'unexisting')
      @mover.mv
      @mover.not_moved.should have(1).item
    end
    
  
    it 'should remove expected file' do
      @mover.mv
      File.file?(File.join(@source_dir, @file)).should be_false
    end
    
    context 'when files include a file in a nested dir' do
      before do
        @mover.instance_variable_set('@files', [@file_without_ext, @nested_file_without_ext])
      end

      it 'should create expected file from nested one' do
        @mover.mv
        File.join(@target_dir, @nested_file).should be_a_file
      end
      
      it 'should remove source nested file' do
        @mover.mv
        @nested_file_path.should_not be_a_file
      end
    end
  end
  
  context 'a mover with only one target directory set' do
    before { @mover = Mover.new(prog_bar, [@file_without_ext], @source_dir, @target_dir) }
    
    it 'should create expected file' do
      @mover.mv
      File.join(@target_dir, @file).should be_a_file
    end
    
    it 'should remove expected file' do
      @mover.mv
      File.join(@source_dir, @file).should_not be_a_file
    end
    
    it 'should not remove files to to be moved' do
      @mover.mv
      @not_moved_file_path.should be_a_file
      @nested_file_path.should be_a_file
    end
  end
end