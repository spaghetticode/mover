require File.dirname(__FILE__) + '/../movable_file'
describe MovableFile do
  
  def current_path
    File.dirname(__FILE__)
  end
  
  before do
    @source_file, @target, @second_target = "#{current_path}/origin/test.txt", "#{current_path}/target", "#{current_path}/second_target"
    system "touch #{@source_file}"
    @not_moved_file = "#{current_path}/origin/not_moved.pdf"
    system "touch #{@not_moved_file}"
    @file = MovableFile.new(@source_file, @target, @second_target)
    FileUtils.rm(@file.target_file) if File.file?(@file.target_file)
    FileUtils.rm(@file.second_target_file) if File.file?(@file.second_target_file)    
    File.file?(@file.source_file).should be_true
    File.file?(@not_moved_file).should be_true
  end
  
  it 'should set all attributes' do
    @file.basename.should == 'test.txt'
    @file.target_file.should == "#{@target}/#{@file.basename}"
    @file.source_file.should == @source_file
    @file.second_target_file.should == "#{@second_target}/#{@file.basename}"
  end
  
  it 'should leave second_target_file blank' do
    file = MovableFile.new(@source_file, @target)
    file.second_target_file.should be_nil
  end
  
  it 'should not be copied' do
    @file.should_not be_copied
  end
  
  context 'when the file has been copied to the target folders' do
    before do
      File.should_receive(:file?).with(@file.target_file).and_return(true)
      File.should_receive(:file?).with(@file.second_target_file).and_return(true)
    end
    
    it 'it should be copied' do
      @file.should be_copied
    end
  end
  
  context 'when the file has been copied to the target forlder' do
    before do
      @file.should_receive(:second_target_file).and_return(nil)
      File.should_receive(:file?).with(@file.target_file).and_return(true)
    end
    
    it 'should be copied' do
      @file.should be_copied
    end
  end
  
  describe 'RM' do    
    it 'should delete source_file file' do
      @file.rm
      File.file?(@file.source_file).should be_false
    end
  end
  
  describe 'COPY' do
    it 'should create copy files' do
      @file.copy
      File.file?(@file.target_file).should be_true
      File.file?(@file.second_target_file).should be_true
    end
  end
  
  describe 'MV' do
    it 'should copy file' do
      @file.mv
      File.file?(@file.target_file).should be_true
      File.file?(@file.second_target_file).should be_true
    end
    
    it 'should remove original file' do
      @file.mv
      File.file?(@file.source_file).should be_false      
    end
    
    it 'should not copy file not included in list' do
      @file.mv
      File.file?(@not_moved_file).should be_true
    end
  end
end