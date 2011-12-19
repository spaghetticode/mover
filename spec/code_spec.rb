describe Code do
  before do
    @invalid = 'A-12-C'
    @with_control_number    = 'D-01-A-8-14'
    @without_control_number = 'D-01-A-15'
  end
  
  describe 'a code instance' do
    let(:invalid) { Code.new('A-12-C-1-123') }
    let(:valid) { Code.new(@with_control_number) }
    let(:valid_without_control) { Code.new(@without_control_number)}
    
    describe '#clean' do
      context 'when code has control number' do
        it 'should remove it' do
          valid.clean.should == 'D-01-A-8'
        end
      end

      context 'when code has no control number' do
        it 'should return the original code value' do
          valid_without_control.clean.should == @without_control_number
        end
      end
    end

    describe '#valid?' do
      context 'when code is valid' do
        it { valid.should be_valid }
      end

      context 'when code is invalid' do
        it { invalid.should_not be_valid }
      end
    end

    describe '#year_number' do
      it { valid.year_number.should be_a(Integer) }

      it 'should be the position of letter in the alphabet' do
        valid.year_number.should == 4
      end
    end

    describe '#month' do
      it { valid.month.should be_a(Integer) }

      it 'should be as expected' do
        valid.month.should == 1
      end
    end

    describe '#designer_number' do
      it { valid.designer_number.should be_a(Integer) }

      it 'should be the position of letter in the alphabet' do
        valid.designer_number.should == 1
      end
    end
    
    describe '#control_code' do
      context 'when there is a control code' do
        it { valid.control_code.should be_a(Integer) }

        it 'should be as expected' do
          valid.control_code.should == 14
        end
      end
      
      context 'when there is no control code' do      
        it 'should be nil' do
          valid_without_control.control_code.should be_nil
        end
      end
    end
  end
  
  describe 'an instance invalid for formats' do
    it 'year should not be valid' do
      ['a1-12-c-11', '2-12-c-11', 'aa-12-c-11'].each do |code|
        Code.new(code).year_valid?.should be_false
      end
    end
    
    it 'month should not be valid' do
      ['A-13-c-12', 'A-a1-c-12', 'A-1c-c-12', 'a-0-c-12'].each do |code|
        Code.new(code).month_valid?.should be_false
      end
    end
    
    it 'designer should not be valid' do
      ['a-12-c1-11', 'a-12-2-11', 'a-12-cc-11'].each do |code|
        Code.new(code).designer_valid?.should be_false
      end
    end
    
    it 'count should not be valid' do
      ['a-12-c-0', 'a-12-c-c1', 'a-12-c-1c'].each do |code|
        Code.new(code).count_valid?.should be_false
      end
    end
    
    it 'should not be valid if parts are not valid' do
      Code.new('DA-01-A-15').should_not be_valid
    end
  end
end