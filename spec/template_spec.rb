require File.join( File.dirname(__FILE__), '..', 'lib',"jzform" )

include JZForm

describe JZForm::Template do
  describe "initialization" do
    it "should take a path to the template directory" do
      lambda {
        Template.new(File.join( File.dirname(__FILE__), '..', 'lib',"jzform","templates" ))
      }.should_not raise_error
    end

    it "should raise a FileNotFound error it the directory does not exist" do
      lambda {
        Template.new(File.join( File.dirname(__FILE__), 'foobar'))
      }.should raise_error
    end
   end

  describe "recognized formats" do
    before(:all) do
      @t = Template.new(File.join( File.dirname(__FILE__), 'templates'))
    end

    before(:each) do
      @obj = mock("context object")
    end

    it "haml" do
      @obj.should_receive(:hi_from).with("form.haml.html")
      @t.template_for(@obj,:html,:form).call(@obj)
    end

    it "ruby script" do
      @obj.should_receive(:hi_from).with("form.screen.rb")
      @t.template_for(@obj,:screen,:form).call(@obj)
    end

  end



end