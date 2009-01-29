require File.join( File.dirname(__FILE__), '..', 'lib',"jzform" )

describe "JZForm::Form Validations:" do
  before(:each) do
    @form = JZForm.new(:name=>'form')
    @form << {:name=>'basic',:datatype=>:string}
    @answer = {'basic'=>'foobar'}
  end

  describe "values" do
    describe "when a valid answer is provided" do
      before(:each) do
        @form.value = @answer
      end

      it "should be valid" do
        @form.should be_valid
      end

      it "should provide a value when it is valid" do
        @form.value.should ==(@answer)
      end

      it "should not have errors in the rendered hash" do
        @form.render(:hash).should_not have_key(:errors)
      end

    end
    describe "when an invalid answer is provided" do
      before(:each) do
        @form.exclusive=true
        @answer[:foo] = 'bar'
        @form.value = @answer
      end

      it "should return nil for a value with an invalid answer" do
        @form.value.should be_nil
      end

      it "should have errors" do
        @form.errors.length.should > 0
      end

      it "should have a current value" do
        @form.current_value.should == @answer
      end

      it "there should be errors in a rendered hash" do
        @form.render(:hash)[:errors].should_not be_nil
      end

    end

    describe "when a valid answer is provided in a hash" do
      before(:each) do
        @form.exclusive = true #will help to make tests fail more easily
        @form.value = {'form'=>@answer}
      end

      it "should be valid" do
        @form.should be_valid
      end

      it "should provide a value when it is valid" do
        @form.value.should ==(@answer)
      end

      it "should not have errors in the rendered hash" do
        @form.render(:hash).should_not have_key(:errors)
      end

    end
  end

  describe "Whole form" do
    describe "with exclusivity" do
      before(:each) do
        @form.exclusive = true
      end
      describe "and valid data" do
        before(:each) do
          @form.value = @answer
        end

        it "should be valid" do
          #puts @form.errors unless @form.valid?
          @form.should be_valid
        end

      end

      describe "and invalid data" do
        before(:each) do
          @answer[:foo] = 'bar'
          @form.value = @answer
        end

        it "should NOT be valid" do
          @form.should_not be_valid
        end

        it "should have one error" do
          @form.errors.length.should == 1
          @form.errors[0][:message].should match(/foo/)
          @form.errors[0][:message].should match(/exclusive/)
        end

      end

    end

  end

  describe " of fields" do
    before(:each) do
      @form << {:name=>'req',:datatype=>:string, :validations=>{:not_empty=>true}}
      @answer['req'] = 'present'
    end

    it "should NOT be valid if any field is invalid" do
      @answer.delete 'req'
      @form.value = @answer
      @form.should_not be_valid
    end

    it "should be valid if all fields are valid" do
      @form.value = @answer
      @form.should be_valid
      @form.value.should ==(@answer)
    end
  end

end