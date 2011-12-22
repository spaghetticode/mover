describe Cleaner do
  describe '#remove_control_codes' do
    let(:cleaner) { Cleaner.new(['A-01-C-12-123', 'C-12-L-1-4', 'B-10-K-666']) }

    it 'should return a string with codes with control code removed' do
      cleaner.remove_control_codes.should == "A-01-C-12\nC-12-L-1\nB-10-K-666"
    end
  end
end