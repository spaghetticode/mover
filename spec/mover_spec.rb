describe Mover do
  def basename_path
    File.dirname(__FILE__)
  end
  
  def prepare_fs
    @file_path = File.join(@source_dir, @file)
    @not_moved_file_path = File.join(@source_dir, @not_moved_file)
    @nested_file_path = File.join(@source_dir, 'nested/down', @nested_file)
    # creo i file:
    [@file_path, @not_moved_file_path, @nested_file_path].each do |file|
      system "touch #{file}"
      File.file?(file).should be_true
    end
    # pulisco le cartelle di destinazione:
    [@target_dir, @second_target_dir].each do |dir|
      [@file, @not_moved_file, @nested_file].each do |file|
        path = File.join(dir, file)
        system "rm #{path}" if File.file?(path)
      end
    end
  end
  
  before do
    @file = 'test.txt'
    @not_moved_file = 'not_moved.pdf'
    @nested_file = 'nested.jpg'
    @source_dir, @target_dir, @second_target_dir = "#{basename_path}/origin", "#{basename_path}/target", "#{basename_path}/second_target"
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
    
    it 'shoould not remove files that should not be moved' do
      @mover.mv
      File.file?(@not_moved_file_path).should be_true
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
      @mover.instance_variable_set('@file', @mover.files << 'not moved.txt')
      @mover.mv
      @mover.not_moved.should include('not moved.txt')
    end
  
    it 'should remove expected file' do
      @mover.mv
      File.file?(File.join(@source_dir, @file)).should be_false
    end
    
    context 'when files include a file in a nested dir' do
      before do
        @mover.instance_variable_set('@files', [@file, @nested_file])
      end

      it 'should create expected file from nested one' do
        @mover.mv
        File.file?(File.join(@target_dir, @nested_file)).should be_true
      end

      it 'should remove source nested file' do
        @mover.mv
        File.file?(@nested_file_path).should be_false
      end
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
    
    it 'should not remove files to to be moved' do
      @mover.mv
      File.file?(@not_moved_file_path).should be_true
      File.file?(@nested_file_path).should be_true
    end
  end
end