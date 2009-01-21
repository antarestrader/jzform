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
        @form.value = @answer
        @form.value.should ==(@answer)
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
    end
  end

  describe "Whole form" do
    describe "with exclusivity" do
      before(:each) do
        @form.exclusive = true
      end
      describe "and invalid data" do
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

      end

    end

  end
end