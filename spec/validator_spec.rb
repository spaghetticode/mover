describe Validator do
  let(:validator) { Validator.new(['D-01-A-1', 'D-01-A-8-11', 'D-01-A-8-15']) }

  describe '#validate' do
    it 'should return an array of invalid codes' do
      validator.validate.should be_an(Array)
    end
    
    it 'should return expected invalid codes quantity' do
      validator.validate.size.should == 2
    end
  end
  
  describe '#invalid_codes' do
    before { validator.validate }

    it 'should return expected string' do
      validator.invalid_codes.should == 'D-01-A-8-11 D-01-A-8-15'
    end
  end
end