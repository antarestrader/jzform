module JZForm
  class Field

    attr_reader :datatype
    attr_accessor :template
    attr_accessor :format
    attr_accessor :name
    attr_accessor :label
    attr_reader :errors
    attr_accessor :validations

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

      @datatype = hash.delete(:datatype).to_sym
      @name = hash.delete(:name)
      @label = hash.delete(:label) || @name
      @options = hash.delete(:options)
      @format = hash.delete(:format)
      @fromat = @format.to_sym unless @format.nil?
      @value = hash.delete(:value) || hash[:default] || nil
      @default = hash.delete(:default)
      @errors = []
      @validations = hash.delete(:validations) || {}
    end

    def valid?
      @errors.empty?
    end

    def value=(input)
      @value = input
      validate
    end

    def value
      valid? ? @value : nil
    end

    def current_value;@value;end
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

    def validate
      @errors = []
      send("validate_#{datatype}")
    end

  private

    def validate_string
      if validations[:not_empty]
        if @value.nil? || @value.empty?
          @errors << "This field cannot be empty"
        end
      end

      if validations[:match] && !@value.nil?
        unless @value =~ validations[:match]
          @errors << "This field did not match the expected pattern: #{validations[:match].to_s}"
        end
      end

      if (validations[:length] || validations[:min_length]) && !@value.nil?
        r = validations[:length]
        min = (r.kind_of?(Range) ? r.min : (validations[:min_length] || 0))
        max = (r.kind_of?(Range) ? r.max : r)
        @errors << "This field must at least #{min} charactors" if @value.length < min
        @errors << "This field can be at most #{max} charactors" if max && @value.length > max
      end
    end

    def validate_integer
      unless @value.kind_of? Integer
        if @value.kind_of? String
          if @value.empty?
            @value = nil
          else
            begin
              @value = Integer(@value)
            rescue ArgumentError
              @errors << "Format not understood: could not convert '#{@value}' to an integer"
            end
          end
        else
          @value.to_i
        end
      end

      if validations[:not_empty] && @value.nil?
        @errors << "This field cannot be empty"
      end

      if (validations[:minimum] || validations[:maximum] || validations[:range]) && !@value.nil?
        if validations[:range] && !validations[:range].kind_of?(Range)
          if validations[:range].to_s =~ /^\(?(-?\d+(?:\.\d+)?)\)?\.\.\(?(-?\d+(?:\.\d+)?)\)?/
            validations[:range] = ($1.to_i)..($2.to_i)
          else
            raise ArgumentError, ":range must be in the format #..#"
          end
        end
        min = validations[:minimum] || (validations[:range] && validations[:range].min)
        max = validations[:maximum] || (validations[:range] && validations[:range].max)
        if min && @value < min
          @errors << "This field must be at least #{min}"
        end
        if max && @value > max
          @errors << "This field can be at most #{max}"
        end

      end

    end

    def validate_number

    end

    def render_structured(format)
      ret = Hash.new
      ret[:datatype]=@datatype
      ret[:name]=@name
      ret[:options]=@options
      ret = ret.delete_if {|k,v| v.nil?}
      method = "to_#{format}"
      ret.send(method.to_sym)
    end

    def field_name
      prefix = @render_opts[:prefix]
      if prefix
        prefix + (@name ? "[#{@name}]" : "[]")
      else
        @name || 'field[]'
      end
    end

  end
end