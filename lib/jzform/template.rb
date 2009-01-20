require 'fileutils'

module JZForm
  def self.template_for(obj,format,structure)
    template_containter = obj.template || DEFAULT_TEMPLATE
    template_containter.template_for(obj,format,structure)
  end

  class Template
    class Runner
      def initialize(path)
        @file = path
        @script = File.read(path)
      end

      def call(scope)
        if scope.is_a?(Binding) || scope.is_a?(Proc)
          scope_object = eval("self", scope)
          scope = scope_object.instance_eval{binding} if block_given?
        else
          scope_object = scope
          scope = scope_object.instance_eval{binding}
        end
        eval(@script, scope, @file, 0)
      end
    end #Runner



    def initialize(template_path)
      raise FileNotFound, "#{template_path} not found" unless File.exists?(template_path)
      @path = template_path
      @cache = {}
    end

    def template_for(obj,format,structure)
      structure = obj.datatype if structure == :input
      @cache[format] ||= {}
      if (!@cache[format][structure])
        file_name = "/**/#{structure}.#{format}.*"
        file = Dir.glob(File.join(@path,file_name))[0]
        raise ArgumentError, "#{file_name} not found" if !file
        puts
        case File.extname(file) #TODO Add Formats
          when '.haml'
            @cache[format][structure] = haml(file)
          when '.rb'
            @cache[format][structure] = script(file)
          else
            raise ArgumentError('Bad File Type')
        end
      end
      @cache[format][structure]
    end

  private

    def haml(file_name)
      Haml::Engine.new(File.read(File.expand_path(file_name ))).method(:to_html)
    end

    def script(file)
      Runner.new(file)
    end

  end

  DEFAULT_TEMPLATE = Template.new(File.join(File.dirname(__FILE__), 'templates'))
end