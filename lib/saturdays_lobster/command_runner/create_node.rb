module SaturdaysLobster
  class CommandRunner
    class CreateNode < Struct.new(:syntax_tree)
      def run
        (returned_node + created_stats).join("\n")
      end

      def returned_node
        if not syntax_tree.return.empty?
          hash = created_node.properties.map { |key, value| "#{key}:#{value.inspect}" }.join(',')
          [
            syntax_tree.return.variable.text_value,
            "Node[#{created_node.id}]{#{hash}}",
            '1 row'
          ]
        else
          []
        end
      end

      def created_stats
        [
          "Nodes created: 1",
          "Properties set: #{created_node.properties.size}",
          "Labels added: #{created_node.labels.size}",
        ]
      end

      def created_node
        @created_node ||= Node.from_syntax_tree(syntax_tree.node)
      end
    end
  end
end
