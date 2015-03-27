module SaturdaysLobster
  class CommandRunner < Struct.new(:command)
    def run
      if parsed.nil?
        parser.failure_reason
      else
        [
          'Nodes created: 1',
          "Properties set: #{property_count}",
          'Labels added: 1',
        ].join("\n")
      end
    end

    def property_count
      parsed
        .node
        .elements[2]
        .elements[1]
        .elements
        .size + 1
    end

    def parser
      @parser ||= QueryParser.new
    end

    def parsed
      @parsed ||= parser.parse(command)
    end
  end
end
