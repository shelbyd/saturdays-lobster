$LOAD_PATH.unshift File.expand_path './lib', File.dirname(__FILE__)

require 'machine_query'

def run_query(query)
  tree = MachineQuery.new(query).eval_trees.first

  while (row = tree.next)
    puts row
  end
end

(ARGV[0] || 0).to_i.times do
  run_query insert: {id: rand(100000000), name: rand(16 ** 8).to_s(16).upcase }
end

# run_query({})
