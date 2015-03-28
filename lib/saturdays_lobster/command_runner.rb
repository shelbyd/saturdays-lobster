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
        (returned_node + created_states).join("\n")
      end
    end

    def returned_node
      if not parsed.return.empty?
        hash = properties.map { |key, value| "#{key}:#{value}" }.join(',')
        [
          parsed.return.variable.text_value,
          "Node[1]{#{hash}}",
          '1 row'
        ]
      else
        []
      end
    end

    def created_states
      [
        "Nodes created: #{node_count}",
        "Properties set: #{property_count}",
        "Labels added: #{label_count}",
      ]
    end

    def property_count
      unless properties.nil?
        properties.keys.size
      else
        0
      end
    end

    def properties
      if not hash.empty?
        hash
          .properties
          .eval
      else
        {}
      end
    end

    def hash
      parsed
        .node
        .hash
    end

    def node_count
      1
    end

    def label_count
      parsed
        .node
        .labels
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
