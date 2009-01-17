require File.join( File.dirname(__FILE__), '..', 'lib',"jzform" )
require 'nokogiri'

describe "JZForm::Field html" do
  before(:each) do
    @html = html(:datatype=>:string, :name=>'name', :prefix=>'user' )
  end

  it "should be a <div> block with a class of 'jzform-field'" do
    @html.css("div.field").should_not be_empty
  end

  it "should have an input field" do
    @html.css(".field input").should_not be_empty
  end

  describe "the input field" do

    describe "name" do

      it "without prefix should be name param" do
        html(:datatype=>:string, :name=>'name').css("input[name='name']").should_not be_empty
      end

      it "when empty should be 'field'" do
        html(:string).css("input[name='field']").should_not be_empty
      end

      it "with a prefix should be prefix[name]" do
        html(:datatype=>:string, :name=>'name', :html=>{:prefix=>'user'} ).css("input[name='user[name]']").should_not be_empty
      end

      #TODO: check this with form processor
      it "with a prefix but no name should be just the prefix" do
        html(:datatype=>:string, :html=>{:prefix=>'user'} ).css("input[name='user']").should_not be_empty
      end

    end

    describe "types" do
      it "with string should have a text type" do
        html(:string).css("input[type=text]").should_not be_empty
      end

      it "with boolean should have a checkbox type" do
        html(:boolean).css("input[type=checkbox]").should_not be_empty
      end

      it "with integer should have a text type" do
        html(:integer).css("input[type=text]").should_not be_empty
      end

      it "with number should have a text type" do
        html(:number).css("input[type=text]").should_not be_empty
      end

    end

    describe "with selection" do
      it "should have a select instead of an input" do
        h = html(%w{Blue Yellow Red Green Purple})
        h.css("input").should be_empty
        h.css("select").should_not be_empty
      end
    end

  end

end

#this function returns the parsed(nokogiri) html for the from created by
#passing the args to from new. Pass html options as options
def html(*args)
  if args[-1].kind_of? Hash
    html_args = args[-1].delete(:html)
  end
  field = JZForm::Field.new(*args)
  Nokogiri::XML.parse(field.to_html(html_args))
end