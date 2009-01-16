require 'haml'
__DIR__ = File.expand_path(File.dirname(__FILE__))
require File.expand_path(File.join(__DIR__, 'jzform', 'form'))
require File.expand_path(File.join(__DIR__, 'jzform', 'field'))

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