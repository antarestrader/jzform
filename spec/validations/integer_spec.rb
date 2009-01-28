require File.join( File.dirname(__FILE__), '..','..', 'lib',"jzform" )

describe "String Field Validation:" do
  before(:each) do
    @field = JZForm::Field.new(:integer)
  end

  describe "without any rules" do
    it "should validate with an integer" do
      @field.value = 10
      @field.should be_valid
      @field.errors.should be_empty
      @field.value.should ==10
    end

    it "should validate with a properly formatted string" do
      @field.value = '10'
      @field.should be_valid
      @field.errors.should be_empty
      @field.value.should ==10
    end

    it "should NOT validate with a poorly formatted string" do
      @field.value = "foobar"
      @field.should_not be_valid
      @field.errors.length.should == 1
      @field.errors[0].should match(/format/i)
      @field.value.should ==nil
      @field.current_value.should =="foobar"
    end

    it "should validate and be nil with an empty string" do
      @field.value = ''
      @field.should be_valid
      @field.errors.should be_empty
      @field.value.should be_nil
    end

    it "should validate and be nil with an nil" do
      @field.value = nil
      @field.should be_valid
      @field.errors.should be_empty
      @field.value.should be_nil
    end

  end

  describe "with not_empty" do
    before(:each) do
      @field.validations[:not_empty] = true
    end

    it "should NOT validate with nil" do
      @field.value = nil
      @field.should_not be_valid
      @field.errors.length.should == 1
      @field.errors[0].should match(/empty/i)
      @field.value.should ==nil
      @field.current_value.should ==nil
    end

    it "should NOT validate with an empty string" do
      @field.value = ''
      @field.should_not be_valid
      @field.errors.length.should == 1
      @field.errors[0].should match(/empty/i)
      @field.value.should ==nil
      @field.current_value.should ==nil
    end

    it "should validate with 0" do
      @field.value = '0'
      @field.should be_valid
      @field.errors.should be_empty
      @field.value.should ==0
    end

  end

  describe "with minimum maximum and range" do
    it "should NOT validate when less then minimum" do
      @field.validations[:minimum] = 10
      @field.value = "5"
      @field.should_not be_valid
      @field.errors.length.should == 1
      @field.errors[0].should match(/at least/i)
      @field.errors[0].should match(/10/)
      @field.value.should ==nil
      @field.current_value.should ==5
    end

    it "should NOT validate when more then maximum" do
      @field.validations[:maximum] = 5
      @field.value = "10"
      @field.should_not be_valid
      @field.errors.length.should == 1
      @field.errors[0].should match(/at most/i)
      @field.errors[0].should match(/5/)
      @field.value.should ==nil
      @field.current_value.should ==10
    end

    it "should validate with a number between minumum and maximum" do
      @field.validations[:minimum] = -10
      @field.validations[:maximum] = 5
      @field.value = '0'
      @field.should be_valid
      @field.errors.should be_empty
      @field.value.should ==0
    end

    it "should NOT validate when the value is out of range" do
      @field.validations[:range] = 0..5
      @field.value = "10"
      @field.should_not be_valid
      @field.value = "-1"
      @field.should_not be_valid
    end

    it "should validate with a number in range" do
      @field.validations[:range] = 0..5
      @field.value = '0'
      @field.should be_valid
      @field.errors.should be_empty
      @field.value.should ==0
    end

    it "should validate with a number in range with range as string" do
      @field.validations[:range] = "-2..5"
      @field.value = '0'
      @field.should be_valid
      @field.errors.should be_empty
      @field.value.should ==0
    end

  end


end