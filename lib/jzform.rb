require 'haml'


require File.join(File.dirname(__FILE__), 'jzform','form')
require File.join(File.dirname(__FILE__), 'jzform','field')
require File.join(File.dirname(__FILE__), 'jzform','template')

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
end