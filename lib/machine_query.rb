require 'nodes'

class MachineQuery < Struct.new(:query)
  def eval_trees
    [
      Nodes::Source
    ]
  end
end
