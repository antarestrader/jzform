require 'json'

module JZForm
  class Form

    attr_reader :fields
    attr_accessor :template
    attr_accessor :name  #named used in the return hash
    attr_accessor :title #form title for display
    attr_accessor :description #What this form does
    attr_accessor :instructions #how to fill out this form
    attr_accessor :exclusive #only fields listed may be present
    attr_accessor :errors #errors in validating

    def initialize(opts={})
      @fields = []
      %w{name title description instructions}.each do |attrib|
        instance_variable_set("@#{attrib}",opts[attrib.to_sym])
      end
      @errors = []
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
        when :json, :yaml, :hash #structured formats
          render_structured(format)
        else
          JZForm.template_for(self,format,:form).call(self)
      end
    end

    def value=(input)
      @value = input
      @errors = []
      input.each do |key, val|
        unless find_field(key)
          @errors << {:message=>"Unknown field(#{key}) found in exclusive form"}
        end
      end if @exclusive
    end

    def value
      valid? ? @value : nil
    end

    def valid?
      @errors.empty?
    end

    def render_structured(format)
      ret = Hash.new
      ret[:fields] = @fields.map {|f| f.render(:hash)}
      add_decoration(ret)
      ret = ret.delete_if {|k,v| v.nil?}
      method = "to_#{format}"
      ret.send(method.to_sym)
    end

    def inspect
      "#<JZForm::Form name=#{@name}, #{@fields.length} fields>"
    end


  private
    def html_options
      {:method=>'post', :name=>@name}
    end

    def add_decoration(hash)
      %w{name title description instructions}.each do |attrib|
        hash[attrib.to_sym] = instance_variable_get("@#{attrib}")
      end
    end

    def find_field(key)
      @fields.find {|field| field.name == key}
    end

  end
end