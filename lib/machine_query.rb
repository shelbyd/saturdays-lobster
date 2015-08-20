require 'nodes'

class MachineQuery < Struct.new(:query)
  def eval_trees
    if query[:insert]
      [Nodes::Insert.new(query[:insert])]
    else
      source = Nodes::Source.new
      if query[:equals]
        [Nodes::Filter.new(Nodes::Source.new, query[:equals])]
      else
        [Nodes::Source.new]
      end
    end
  end
end
