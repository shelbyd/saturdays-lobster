$LOAD_PATH.unshift File.expand_path './lib', File.dirname(__FILE__)

Signal.trap('PIPE', 'EXIT')

require 'machine_query'
require 'variable'

def run_query(query)
  tree = MachineQuery.new(query).eval_trees.first
  rows = []

  while (row = tree.next)
    rows << row
    puts row
  end

  puts "#{rows.size} row#{rows.size == 1 ? '' : 's'}"
end

(ARGV[0] || 0).to_i.times do
  run_query insert: {id: rand(1000), name: rand(16 ** 8).to_s(16).upcase }
end

# run_query({
#   make_fast: {
#     equals: {
#       id: Variable.new
#     }
#   }
# })

run_query({
  equals: {
    id: 42,
  }
})
