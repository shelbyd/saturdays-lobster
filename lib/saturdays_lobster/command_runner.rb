module SaturdaysLobster
  class CommandRunner < Struct.new(:command)
    def run
      if parsed.nil?
        [
          parser.input.strip,
          ' ' * (parser.failure_column - 1) + '^',
          parser.failure_reason,
        ].join("\n")
      else
        CreateNode.new(parsed).run
      end
    end

    def parser
      @parser ||= CommandParser.new
    end

    def parsed
      @parsed ||= parser.parse(command)
    end
  end
end

require 'saturdays_lobster/command_runner/create_node'
