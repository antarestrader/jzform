Screw.Unit(function() {
  describe('Building a form',function() {
    before(function() {
      form = new JZForm({"fields":[{"datatype":"string","name":"username","label":"Username","validations":{}}],"name":"json-test","title":"JSON Test","action":"Go"});
      form.build('#dom_test')
    });

    it("should build a form at a location", function() {
      expect(jQuery('#dom_test>.jzform').length).to_not(equal,0);
    });

    it("should have the correct name", function() {
      expect(jQuery('#dom_test>.jzform').attr('name')).to(equal,'json-test');
    });

    it("should contain a fieldset", function() {
      expect(jQuery('#dom_test>.jzform')).to(contain_selector,'fieldset');
    });

    it("should have a title", function() {
      expect(jQuery('#dom_test>.jzform legend').text()).to(equal,'JSON Test');
    });

    it("should have a submit button", function() {
      expect(jQuery('#dom_test>.jzform button').text()).to(equal,'Go');
    });

    describe("fields",function() {
      it("should have a text field",function() {
        expect(jQuery('#dom_test>.jzform>fieldset')).to(contain_selector,'input[type=text]');
      })
    });

  });
});