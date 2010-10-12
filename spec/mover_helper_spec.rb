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
    FileAdapter.convert(files).should == %w[B-09-M-32.jpg A-08-C-42.jpg A-02-WW-73.jpg]
  end
end

describe Array do
  it 'should group items' do
    [1,2,3,4,5].join_in_groups_of(2).should == "1 2\n3 4\n5"
  end
end