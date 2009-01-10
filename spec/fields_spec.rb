require File.join( File.dirname(__FILE__), '..', 'lib',"jzform" )

include JZForm

BASIC_TYPES = %w{string integer number selection set boolean}

describe JZForm::Field do
  describe "when initializing" do
    it "should NOT accept bad datatypes" do
      lambda{Field.new(:foobar)}.should raise_error(ArgumentError)
    end

    it "should accept symbols for basic types" do
      BASIC_TYPES.each {|dt| lambda{Field.new(dt.to_sym)}.should_not raise_error}
    end

    it "should accept strings for basic types" do
      BASIC_TYPES.each {|dt| lambda{Field.new(dt)}.should_not raise_error}
    end

    it "should accept a hash with symbols" do
      lambda{Field.new(:datatype=>:string)}.should_not raise_error
    end

    it "should accept a hash with strings" do
      lambda{Field.new('datatype'=>'string')}.should_not raise_error
    end

  end

  describe "with array datatype" do
    it "should accept and array" do
      f = Field.new(%w{red green blue yellow orange teal})
      f.datatype.should ==(:selection)
    end
  end

  describe "with form datatype" do
    it "should accept a form" do
      lambda{Field.new(JZForm.new)}.should_not raise_error
    end

    it "should have a datatype of form" do
      Field.new(JZForm.new).datatype.should ==(:form)
    end
  end

  it "should have and datatype" do
    Field.new(:string).datatype.should ==(:string)
  end

end