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
        [
          "Nodes created: #{node_count}",
          "Properties set: #{property_count}",
          "Labels added: #{label_count}",
        ].join("\n")
      end
    end

    def property_count
      unless properties.nil?
        properties[1]
          .elements
          .size + 1
      else
        0
      end
    end

    def properties
      parsed
        .node
        .elements[2]
        .elements
    end

    def node_count
      1
    end

    def label_count
      parsed
        .node
        .elements[0]
        .elements
        .size
    end

    def parser
      @parser ||= CommandParser.new
    end

    def parsed
      @parsed ||= parser.parse(command)
    end
  end
end
