class DevSystem::StickLog < DevSystem::Log
  class Error < Error; end
  class MissingText < Error; end
  class UnknownArg < Error; end

  FORE = [255, 255, 255]
  STYLES = {
    bold: :b,
    italic: :i,
    underlined: :u,
  }

  attr_reader :text, :fore, :back, :bold, :italic, :underlined

  def initialize *args
    bold = nil
    italic = nil
    underlined = nil
    fore = nil
    back = nil
    text = nil

    args.each do |arg|
      next text = arg if arg.is_a? String and text.nil?
      
      if arg.is_a? Symbol
        x = STYLES[arg] || arg
        next bold       = true if x == :b
        next italic     = true if x == :i
        next underlined = true if x == :u
      end

      next fore = arg unless fore
      next back = arg unless back
      raise UnknownArg, "unknown arg #{arg.inspect}"
    end

    raise MissingText, "missing a string as text", caller[3..] unless text
    fore ||= FORE

    fore = ColorShell.parse(fore) if fore and not fore.is_a? Array
    back = ColorShell.parse(back) if back and not back.is_a? Array

    # TODO: benchmark alternatives in regards to Object Shapes
    @bold = bold
    @italic = italic
    @underlined = underlined
    @fore = fore
    @back = back
    @text = text.to_s
  end

  def to_s
    s = ""
    s += "\e[1m" if @bold
    s += "\e[3m" if @italic
    s += "\e[4m" if @underlined
    s += "\e[38;2;#{@fore[0]};#{@fore[1]};#{@fore[2]}m" if @fore
    s += "\e[48;2;#{@back[0]};#{@back[1]};#{@back[2]}m" if @back
    s += @text
    s += "\e[0m"
    s
  end
  
end
