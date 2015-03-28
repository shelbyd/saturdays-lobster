module SaturdaysLobster
  class Node
    def self.from_syntax_tree(tree)
      new.tap do |n|
        n.properties = tree.hash.empty? ? {} : tree.hash.properties.eval
        n.labels = tree.labels.eval
        n.id = 1
      end
    end

    attr_accessor :labels
    attr_accessor :properties
    attr_accessor :id
  end
end
