class Hash
  def symbolize_keys
    replace(inject({}) { |h,(k,v)| h[k.to_sym] = v; h })
  end
end

module JZForm
  BASIC_TYPES = [:form, :string, :integer, :number, :selection, :set, :boolean]
  def self.new(*args)
    Form.new(*args)
  end
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

  end

  class Field

    attr_reader :datatype

    def initialize(hash)
      unless hash.kind_of? Hash
        hash = {:datatype=>hash}
      end
      hash.symbolize_keys

      #Auto Convert datatypes
      hash = case hash[:datatype]
        when Form
          {:datatype=>:form, :subform=>hash[:datatype]}
        when Array
          {:datatype=>:selection, :options=>hash[:datatype]}
        else
          hash
      end

      #Ensure that we now have proper datatypes
      unless BASIC_TYPES.include?(hash[:datatype].to_sym)
        raise ArgumentError, "#{datatype} is not a recognized datatype"
      end
      @datatype = hash[:datatype].to_sym
    end
  end
end