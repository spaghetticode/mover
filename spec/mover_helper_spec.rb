describe String do
  it { String.new.should be_blank }
  it { ' '.should be_blank }
  it { '  '.should be_blank }
  it { 'asd'.should_not be_blank }
end

describe NilClass do
  it { nil.should be_blank }
end