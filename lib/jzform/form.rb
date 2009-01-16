module JZForm
  class Form

    attr_reader :fields

    def initialize
      @fields = []
    end

    def add_field(field)
      if field.kind_of?(Array) && field[0].kind_of?(Hash)
        field.each do |f|
          @fields << Field.new(:name=>f.keys[0],:datatype=>f.values[0])
        end
      else
        field = Field.new(field) unless field.kind_of? Field
        @fields << field
        self
      end
    end
    alias_method :<<,:add_field

    def well_formed?;true;end

    def to_html

      haml_engine = Haml::Engine.new(File.read(File.join( File.dirname(__FILE__),'templates', 'form.haml' )))
      haml_engine.to_html(self)
    end

    def html_options
      {:method=>'post', :name=>'name_from_attrs'}
    end

  end
end