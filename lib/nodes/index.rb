module Nodes
  class Index < Struct.new(:id, :values)
    class << self
      def data_path=(path)
        @@data_path = path
      end

      def data_path
        @@data_path ||= './data/production'
      end
    end

    def next
      @index ||= -1
      objects[@index += 1]
    end

    def execution_time
      objects.size
    end

    private

    def objects
      @objects ||= begin
        FileUtils.mkdir_p(File.dirname(index_path))
        FileUtils.touch(index_path)
        File.readlines(index_path).map { |line| JSON.parse(line) }
      end
    end

    def index_path
      "#{self.class.data_path}/index/#{id}/#{values.first}.index"
    end
  end
end
