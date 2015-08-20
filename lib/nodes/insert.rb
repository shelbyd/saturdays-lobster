module Nodes
  class Insert < Struct.new(:row)
    class << self
      def data_path=(path)
        @@data_path = path
      end

      def data_path
        @@data_path ||= './data/production/data'
        @@data_path
      end

      def max_size=(size)
        @@max_size = size
      end

      def max_size
        @@max_size ||= 1024 * 1024 # 1 Megabyte
        @@max_size
      end
    end

    def next
      File.open(current_file, 'a') do |file|
        file.puts row.to_json
      end
    end

    private

    def data_path
      self.class.data_path
    end

    def current_file
      while File.size?("#{data_path}/#{file_index}.data").to_i >= self.class.max_size
        @file_index += 1
      end
      "#{data_path}/#{file_index}.data"
    end

    def file_index
      @file_index ||= 0
    end
  end
end
