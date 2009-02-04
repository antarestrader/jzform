function JZForm(json) {
  this.name = json.name;
  this.title = json.title;
  this.description = json.description;
  this.action = json.action
  this.fields = jQuery.map(json.fields,function(field) {
     f = new JZForm.Field(field);
     f.prefix(json.name);
     return f
  });
};

function build_form(selector) {
  with(this);
  jQuery(selector).html("<form class='jzform'><fieldset></fieldset></form>");
  selector = selector +'>form.jzform';
  jQuery(selector).attr('name',this.name);
  selector = selector +'>fieldset';
  jQuery(selector).append(jQuery('<legend>').text(this.title));
  jQuery.each(this.fields,function(i,field) {
    jQuery(selector).append(field.build())
  });
  jQuery(selector).append(
    jQuery('<button>').text(this.action)
  );
}

JZForm.prototype.build = build_form


JZForm.Field = function(json) {
  this.label = json.label
  this.name = json.name
};

function build_field() {
  with(this)
  ret = jQuery("<div />")
  ret.addClass('field')
  label = jQuery('<label/>')
  label.append(this.label)
  input = jQuery("<input type='text'/>")
  input.attr('name',this.prefix + '['+this.name+']')
  label.append(input)
  ret.append(label)
  return ret
}

function prefix(input) {
  with(this);
  this.prefix = input;
}

JZForm.Field.prototype.build = build_field
JZForm.Field.prototype.prefix = prefix