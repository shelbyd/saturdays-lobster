$: << File.expand_path("../../lib", File.dirname(__FILE__))
require 'saturdays_lobster'

class Output
  def include?(o)
    strings.any? { |s| s.include? o }
  end

  def <<(s)
    strings << s
  end

  def strings
    @strings ||= []
  end

  def inspect
    strings.join("\n").inspect
  end
end

module OutputHolder
  def output
    @output ||= Output.new
  end
end

World(OutputHolder)
