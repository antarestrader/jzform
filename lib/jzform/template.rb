module JZForm
  def self.template_for(obj,format,structure)
    template_containter = obj.template || DEFAULT_TEMPLATE
    template_containter.template_for(obj,format,structure)
  end

  class Template
    def initialize(template_path)
      @path = template_path
    end

    def template_for(obj,format,structure)
      case structure
        when :form
          haml_engine = Haml::Engine.new(File.read(File.join( @path, 'form.haml' )))
          haml_engine.method(:to_html)
        when :field
          haml_engine = Haml::Engine.new(File.read(File.join( @path, 'field.haml' )))
          haml_engine.method(:to_html)
        when :input
          t = obj.datatype.to_s
          haml_engine = Haml::Engine.new(File.read(File.join( @path, 'input', "#{t}.haml" )))
          haml_engine.method(:to_html)
      end
    end

  end

  DEFAULT_TEMPLATE = Template.new(File.join(File.dirname(__FILE__), 'templates'))
end