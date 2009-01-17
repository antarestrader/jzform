module JZForm
  class Field

    attr_reader :datatype
    attr_accessor :template

    def initialize(hash)
      unless hash.kind_of? Hash
        hash = {:datatype=>hash}
      end
      hash.symbolize_keys

      #Auto Convert datatypes
      hash = case hash[:datatype]
        when Form
          hash.merge({:datatype=>:form, :subform=>hash[:datatype]})
        when Array
          hash.merge({:datatype=>:selection, :options=>hash[:datatype]})
        else
          hash
      end

      #Ensure that we now have proper datatypes
      unless BASIC_TYPES.include?(hash[:datatype].to_sym)
        raise ArgumentError, "#{datatype} is not a recognized datatype"
      end
      @datatype = hash[:datatype].to_sym
      @name = hash[:name]
      @options = hash[:options]
    end

    #valid options
    #
    #   :prefix  :  A string to place in front of the name attribute
    def to_html(opts={})
      render(:html,opts)
    end

    def render(format, opts = {})
      @render_opts = opts || {}
      case format
        when :xml, :json, :yaml, :hash #structured formats
          render_structured(format)
        else
          JZForm.template_for(self,format,:field).call(self)
      end
    end

    def input(format)
      JZForm.template_for(self,format,:input).call(self)
    end

    def subforms?
      !@subforms.nil?
    end

  private

    def field_name
      prefix = @render_opts[:prefix]
      if prefix
        prefix + (@name ? "[#{@name}]" : "")
      else
        @name || 'field'
      end
    end

  end
end

#      haml_engine = Haml::Engine.new(File.read(File.join( File.dirname(__FILE__),'templates', 'field.haml' )))
#      haml_engine.to_html(self)