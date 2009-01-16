module JZForm
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

    def to_html
      "<div>#{@datatype.to_s}</div>"
    end
  end
end