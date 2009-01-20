require File.join( File.dirname(__FILE__), '..', 'lib',"jzform" )

include JZForm

describe Template::Runner do
  before(:each) do
    @obj = mock("context object")
    @r = Template::Runner.new(File.join(File.dirname(__FILE__),"/templates/form.screen.rb"))
  end

  it "should call script with object" do
    @obj.should_receive(:hi_from).with("form.screen.rb")
    @r.call(@obj)
  end

end