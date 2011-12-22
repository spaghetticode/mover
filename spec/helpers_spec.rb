describe String do
  it { String.new.should be_blank }
  it { ' '.should be_blank }
  it { '  '.should be_blank }
  it { 'asd'.should_not be_blank }
end

describe NilClass do
  it { nil.should be_blank }
end

describe FileAdapter do
  it { FileAdapter::SPLITTER.should == "\n" }

  describe '.convert' do
    it 'should return expected array' do
      files = "B-09-M-32
      A-08-C-42
      A-02-WW-73"
      FileAdapter.convert(files).should == %w[B-09-M-32 A-08-C-42 A-02-WW-73]
    end

    it 'should remove duplicate entries' do
      files = 'ABC
      BCA
      ABC
      ABC'
      FileAdapter.convert(files).should have(2).items
    end
  end

  describe '.codes' do
    before do
      @codes = 'A-01-C-12 C-12-L-1 B-10-K-666'
    end

    it 'should split the codes string' do
      FileAdapter.codes(@codes).size.should == 3
    end

    it 'should return expected values' do
      FileAdapter.codes(@codes).should == %w[A-01-C-12 C-12-L-1 B-10-K-666]
    end
  end

  describe 'same_dir?' do
    it 'should be false when origin and target dirs are not same/nested' do
      origin = Dir.pwd
      target = Dir.pwd.split('//')[0..-2]
      FileAdapter.same_dir?(target, origin).should be_false
    end

    it 'should be true when origin and target dirs are same' do
      origin = target = Dir.pwd
      FileAdapter.same_dir?(target, origin).should be_true
    end

    it 'should be true when target is nested in origin' do
      origin = Dir.pwd
      target = File.join(origin, 'pizza')
      FileAdapter.same_dir?(target, origin).should be_true
    end
  end

  describe 'tainted?' do
    it 'should be true when dirs end with slash or backslashes' do
      ['dir\\', 'dir\/'].each do |dir|
        FileAdapter.tainted?(dir).should be_true
      end
    end

    it 'should be false when dirs end with valid chars' do
      ['\/pizza', '\\asd'].each do |dir|
        FileAdapter.tainted?(dir).should be_false
      end
    end
  end
end