describe AppConfig do
  context 'when there is no config file to load' do
    context 'when there is no default dir set' do
      it { AppConfig.source_dir.should be_nil }
      it { AppConfig.target_dir.should be_nil }
      it { AppConfig.second_target_dir.should be_nil }
    end
  end
  
  context 'when there is a config file to load' do
    it 'should load expected paths' do
      AppConfig.path = File.dirname(__FILE__) + '/app_config.yml'
      AppConfig.source_dir.should == '/Users/andrea/source'
      AppConfig.target_dir.should == '/Users/andrea/target'
      AppConfig.second_target_dir.should == '/Users/andrea/second_target'
    end
  end
  
  context 'save config' do
    before do
      @path = File.dirname(__FILE__) + '/custom_config.yml'
      AppConfig.path = @path
      AppConfig.save('source_path', 'target_path', 'second_target_path')
    end
    
    after do
      FileUtils.rm(@path) if File.file?(@path)
    end
    
    it 'should create config file' do
      @path.should be_a_file
    end
    
    it 'config file should include expected strings' do
      File.read(@path).should include('source_path')
    end
  end
end
