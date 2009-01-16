require File.join( File.dirname(__FILE__), '..', 'lib',"jzform" )
require 'nokogiri'

describe "jzForm basic html output" do
  before(:each) do
    @form = JZForm.new
    @form.add_field([{:name=>:string}, {:age=>:integer}, {'favorite_color'=>%w{Red Blue Green Yellow}}])
    @resp = Nokogiri::XML.parse(@form.to_html)
  end

  it "should have a root element of <form>." do
    @resp.root.name.should =="form"
  end

  it "should have one <div> for each field" do
    @resp.xpath('/form/div').length.should ==(3)
  end
end