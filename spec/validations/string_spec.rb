require File.join( File.dirname(__FILE__), '..','..', 'lib',"jzform" )

describe "String Field Validation:" do
  before(:each) do
    @field = JZForm::Field.new(:string)
  end

  describe "without any rules" do
    it "should validate with a string" do
      @field.value = "foobar"
      @field.should be_valid
      @field.errors.should be_empty
      @field.value.should =="foobar"
    end

    it "should validate with an empty string" do
      @field.value = ""
      @field.should be_valid
      @field.errors.should be_empty
      @field.value.should ==""
    end

    it "should validate with no data" do
      @field.value = nil
      @field.should be_valid
    end

  end

  describe "when using :not_empty" do
    before(:each) do
      @field.validations << :not_empty
    end

    it "should validate with a string" do
      @field.value = "foobar"
      @field.should be_valid
      @field.errors.should be_empty
      @field.value.should =="foobar"
    end

    it "should NOT validate with an empty string" do
      @field.value = ""
      @field.should_not be_valid
      @field.errors.length.should == 1
      @field.errors[0].should match(/empty/)
      @field.value.should ==nil
      @field.current_value.should ==""
    end

  end

end