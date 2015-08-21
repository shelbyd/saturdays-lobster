require 'nodes'
require 'indexes'

class MachineQuery < Struct.new(:query)
  def eval_trees
    if query[:insert]
      [Nodes::Insert.new(query[:insert])]
    elsif query[:equals]
      equals_trees(query[:equals])
    elsif query[:make_fast]
      [Nodes::MakeFast.new(MachineQuery.new(query[:make_fast]).eval_trees)]
    elsif query == {}
      [Nodes::Source.new]
    else
      raise ArgumentError.new('Unrecognized query')
    end
  end

  def equals_trees(filter)
    return [Nodes::Source.new] if filter.empty?

    tree = Nodes::Filter.new(Nodes::Source.new, filter)
    maybe_index = Indexes.all.find { |index| index.matches? tree }
    index_id = Indexes.all.index(maybe_index)
    return [Nodes::Index.new(index_id, maybe_index.variables.first.values)] if maybe_index

    filter.map do |key, value|
      [Hash[key, value], filter.reject { |k, v| k == key }]
    end.map do |this_filter, remaining_filter|
      equals_trees(remaining_filter).map do |tree|
        Nodes::Filter.new(tree, this_filter)
      end
    end.flatten
  end
end
