require File.join( File.dirname(__FILE__), '..', 'lib',"jzform" )

include JZForm

describe JZForm do
  it "new should take an options hash" do
    f = JZForm.new({
        :name=>'registration',
        :title=>'New User Registration',
        :description=>"User this form to create a new user account.",
        :instructions=>"Enter your informations in the fields provided."
      })
    f.name.should == 'registration'
    f.title.should == 'New User Registration'
    f.description.should == "User this form to create a new user account."
    f.instructions.should == "Enter your informations in the fields provided."
  end

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

  describe "formats:" do
    before(:all) do
      @form = JZForm.new
      @form << {:name=>'username',:datatype=>:string, :label=>'Username', :description=>"The name you will use to log into this site"}
      @form << {:name=>'password',:datatype=>:string, :label=>'Password', :description=>"A password"}
      @form << {:name=>'password_confirmation',:datatype=>:string, :label=>'Confirm Password', :description=>"Retype your password"}
      @form << {:name=>'country',:datatype=>:selection,:options=>%{USA Canada Mexico}, :label=>'Country', :description=>"What country do you live in?"}
    end

    it "hash" do
      h = @form.render(:hash)
      h[:fields].length.should == 4
      h[:fields][3][:datatype].should ==:selection
    end

    it "JSON" do
      json =  @form.render(:json)
    end

    it "YAML" do
      yaml =  @form.render(:yaml)
    end

    it "XML" do
      pending "I hate builders!"
      xml =  @form.render(:xml)
    end

  end

  describe "decorations" do
    before(:each) do
      @form = JZForm.new
    end

    it "should have a name" do
      @form.name = 'registration'
      @form.render(:hash)[:name].should =='registration'
    end

    it "should have: title, description, instructions" do
      f = JZForm.new({
        :name=>'registration',
        :title=>'New User Registration',
        :description=>"User this form to create a new user account.",
        :instructions=>"Enter your informations in the fields provided."
      })
      h = f.render(:hash)
      %w{name title description instructions}.each do |attrib|
        puts "#{attrib} was nil" if h[attrib.to_sym].nil?
        h[attrib.to_sym].should_not be_nil
      end

    end
  end

end