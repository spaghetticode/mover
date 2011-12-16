describe Code do
  before do
    @invalid = 'A-12-C'
    @with_control_number    = 'C-03-A-1-123'
    @without_control_number = 'A-12-C-5'
  end
  
  describe '#initialize' do
    context 'when code value is valid' do
      it 'should not raise error' do
        [@without_control_number, @with_control_number ].each do |code|
          lambda { Code.new(code) }.should_not raise_error
        end
      end
    end
    
    context 'when code value is invalid' do
      it 'should raise error when code is invalid' do
        lambda { Code.new(@invalid) }.should raise_error
      end
    end
  end
  
  describe '#clean' do
    context 'when code has control number' do
      it 'should remove it' do
        Code.new(@with_control_number).clean.should == 'C-03-A-1'
      end
    end
    
    context 'when code has no control number' do
      it 'should return the original code value' do
        Code.new(@without_control_number).clean.should == @without_control_number
      end
    end
  end
end