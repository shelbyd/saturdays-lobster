require 'nodes'
require 'indexes'

class MachineQuery < Struct.new(:query)
  def eval_trees
    if query[:insert]
      [Nodes::Insert.new(query[:insert])]
    elsif query[:equals]
      trees = equals_trees(query[:equals])
      replace_with_indexes(trees)
    elsif query[:make_fast]
      [Nodes::MakeFast.new(MachineQuery.new(query[:make_fast]).eval_trees)]
    elsif query == {}
      [Nodes::Source.new]
    else
      raise ArgumentError.new('Unrecognized query')
    end
  end

  private

  def equals_trees(filter)
    return [Nodes::Source.new] if filter.empty?

    filter.map do |key, value|
      [Hash[key, value], filter.reject { |k, v| k == key }]
    end.map do |this_filter, remaining_filter|
      equals_trees(remaining_filter).map do |tree|
        Nodes::Filter.new(tree, this_filter)
      end
    end.flatten
  end

  def replace_with_indexes(trees)
    @indexes ||= Indexes.all
    trees.map do |tree|
      with_index(tree)
    end
  end

  def with_index(tree)
    index = @indexes.find { |index| index.matches? tree }
    if index
      index_id = @indexes.index(index)
      Nodes::Index.new(index_id, index.variables.first.values)
    else
      if tree.respond_to?(:source)
        tree.source = with_index(tree.source)
      end
      tree
    end
  end
end
