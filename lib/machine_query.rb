require 'nodes'

class MachineQuery < Struct.new(:query)
  def eval_trees
    if query[:insert]
      [Nodes::Insert.new(query[:insert])]
    else
      [Nodes::Source.new]
    end
  end
end
