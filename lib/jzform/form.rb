module JZForm
  class Form

    attr_reader :fields
    attr_accessor :template

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

    def to_html(opts={})
      render(:html, opts)
    end

    def render(format, opts = {})
      @render_opts = opts || {}
      case format
        when :xml, :json, :yaml, :hash #structured formats
          render_structured(format)
        else
          JZForm.template_for(self,format,:form).call(self)
      end
    end

    def html_options
      {:method=>'post', :name=>'name_from_attrs'}
    end

  end
end