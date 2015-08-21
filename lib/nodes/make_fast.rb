require 'yaml'

module Nodes
  class MakeFast < Struct.new(:possible_trees)
    class << self
      def data_path=(path)
        @@data_path = path
      end

      def data_path
        @@data_path ||= './data/production'
      end
    end

    def next
      write_index_definition

      while (row = best_tree.next)
        variable = best_tree.variables.first
        variable.values.each do |value|
          file_path = "#{index_path}/#{index_id}/#{value}.index"
          FileUtils.mkdir_p(File.dirname(file_path))
          FileUtils.touch(file_path)
          File.open(file_path, 'a') do |f|
            f.puts row.to_json
          end
        end
      end
    end

    def execution_time
      0
    end

    private

    def write_index_definition
      FileUtils.mkdir_p("#{data_path}/index/")
      FileUtils.touch(all_index_path)
      indexes = YAML.load(File.read(all_index_path)) || []
      @index_id = indexes.size
      indexes << best_tree
      File.open(all_index_path, 'w') do |file|
        file.puts indexes.to_yaml
      end
    end

    def best_tree
      possible_trees.first
    end

    def data_path
      self.class.data_path
    end

    def all_index_path
      "#{index_path}/all.index"
    end

    def index_path
      "#{data_path}/index"
    end

    def index_id
      @index_id || throw(:index_id_not_set)
    end
  end
end
