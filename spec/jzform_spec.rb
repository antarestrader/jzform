require File.join( File.dirname(__FILE__), '..', 'lib',"jzform" )

describe JZForm do
  describe "when making a new form" do
    before :each do
      @form = JZForm.new
    end

    it "should be well formed" do
      @form.should be_well_formed
    end

    it "should have 0 fields" do
      @form.should have(0).fields
    end
  end

  describe "when adding fields" do
    before :each do
      @form = JZForm.new
    end

    describe "with instance methods" do
      it "should add a Field class" do
        @form.add_field(f = Field.new(:string))
        @form.fields[0].should ==(f)
      end

      it "should add a symbol" do
        @form.add_field(:string)
        @form.fields[0].datatype.should ==(:string)
      end

      it "should add a string" do
        @form.add_field('string')
        @form.fields[0].datatype.should ==(:string)
      end

      it "should add a Form class" do
        @form.add_field(Form.new)
        @form.fields[0].datatype.should ==(:form)
      end

      it "should add a hash" do
        @form.add_field(:datatype=>:string)
        @form.fields[0].datatype.should ==(:string)
      end

      it "should add an array of choices" do
        @form.add_field(%w{Jan. Feb. March April May June July Aug. Sept. Oct. Nov. Dec.})
        @form.fields[0].datatype.should ==(:selection)
      end

      it "should add an array of hashes" do
        @form.add_field([{:name=>:string}, {:quest=>:string}, {'favorite_color'=>['Blue','No, Yellooooww...']}])
        @form.should have(3).fields
      end
    end

    describe "with #<<" do

      it "should add an element to fields" do
        @form << :string
        @form.fields[0].datatype.should ==(:string)
      end

      it "should chain" do
        @form << :string << :integer
        @form.fields[1].datatype.should ==(:integer)
      end

    end



  end
end