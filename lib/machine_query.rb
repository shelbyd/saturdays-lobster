require 'nodes'
require 'indexes'

class MachineQuery < Struct.new(:query)
  def eval_trees
    if query[:insert]
      [Nodes::Insert.new(query[:insert])]
    elsif query[:equals]
      tree = Nodes::Filter.new(Nodes::Source.new, query[:equals])
      maybe_index = Indexes.all.find { |index| index.matches? tree }
      index_id = Indexes.all.index(maybe_index)
      maybe_index ?
        [Nodes::Index.new(index_id, maybe_index.variables.first.values)] :
        [Nodes::Filter.new(Nodes::Source.new, query[:equals])]
    elsif query[:make_fast]
      [Nodes::MakeFast.new(MachineQuery.new(query[:make_fast]).eval_trees)]
    elsif query == {}
      [Nodes::Source.new]
    else
      raise ArgumentError.new('Unrecognized query')
    end
  end
end
