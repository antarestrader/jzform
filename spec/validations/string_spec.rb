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
      @field.validations[:not_empty] = true
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

  describe "'match'" do
    before(:each) do
      @field.validations[:match] = /foo.*/
    end

    it "should validate with a matching string" do
      @field.value = "foobar"
      @field.should be_valid
      @field.errors.should be_empty
      @field.value.should =="foobar"
    end

    it "should NOT validate with a non matching string" do
      @field.value = "baz"
      @field.should_not be_valid
      @field.errors.length.should == 1
      @field.errors[0].should match(/match/)
      @field.value.should ==nil
      @field.current_value.should =="baz"
    end

  end

  describe "'length'" do
    describe "as an integer" do
      before(:each) do
        @field.validations[:length] = 10
      end

      it "should validate with a string shorter then length" do
        @field.value = "foobar"
        @field.should be_valid
        @field.errors.should be_empty
        @field.value.should =="foobar"
      end

      it "should validate with a string exactltly length" do
        @field.value = "0123456789"
        @field.should be_valid
        @field.errors.should be_empty
        @field.value.should =="0123456789"
      end

      it "should NOT validate with a string that is too long" do
        @field.value = "baz baz baz baz"
        @field.should_not be_valid
        @field.errors.length.should == 1
        @field.value.should ==nil
        @field.current_value.should =="baz baz baz baz"
      end

    end

    describe "as a rannge" do
      before(:each) do
        @field.validations[:length] = (5..10)
      end

      it "should validate with a string within" do
        @field.value = "foobar"
        @field.should be_valid
        @field.errors.should be_empty
        @field.value.should =="foobar"
      end

      it "should NOT validate with a string that is too long" do
        @field.value = "baz baz baz baz"
        @field.should_not be_valid
        @field.errors.length.should == 1
        @field.value.should ==nil
        @field.current_value.should =="baz baz baz baz"
      end

      it "should NOT validate with a string that is too short" do
        @field.value = "baz"
        @field.should_not be_valid
        @field.errors.length.should == 1
        @field.value.should ==nil
        @field.current_value.should =="baz"
      end
    end

    describe "with min_length" do
      before(:each) do
        @field.validations[:min_length] = 5
      end

      it "should validate with a string shorter then length" do
        @field.value = "foobar"
        @field.should be_valid
        @field.errors.should be_empty
        @field.value.should =="foobar"
      end

      it "should validate with a string exactltly length" do
        @field.value = "12345"
        @field.should be_valid
        @field.errors.should be_empty
        @field.value.should =="12345"
      end

      it "should NOT validate with a string that is too short" do
        @field.value = "baz"
        @field.should_not be_valid
        @field.errors.length.should == 1
        @field.value.should ==nil
        @field.current_value.should =="baz"
      end

    end

  end

end