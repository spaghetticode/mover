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