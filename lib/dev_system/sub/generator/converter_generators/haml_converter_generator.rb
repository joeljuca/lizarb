class DevSystem::HamlConverterGenerator < DevSystem::ConverterGenerator

  def self.default_options
    DevBox[:generator].converters[:haml][:options]
  end

  # https://github.com/gjtorikian/commonmarker#usage

  # Haml::Template.options[:ugly] = false
  # Haml::Template.options[:format] = :html5
  # Haml::Template.options[:attr_wrapper] = '"'
  # Haml::Template.options[:escape_html] = true

  def self.convert string, options = {}
    log :lower, "default_options = #{default_options.inspect} | options = #{options.inspect}"

    options = default_options.merge options if options.any? && default_options.any?
    
    log :lower, "#{string.size} chars (options: #{options.inspect})"

    haml = string
    # template_options = {escape_html: true}
    template_options = {}
    scope = Object.new
    locals = {}
    require "haml"
    Haml::Template.new(template_options) { haml }.render(scope, locals)
  end

end
