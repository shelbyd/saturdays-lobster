$LOAD_PATH.unshift File.expand_path './lib', File.dirname(__FILE__)

require 'machine_query'

tree = MachineQuery.new({}).eval_trees.first

while (row = tree.next)
  puts row
end
