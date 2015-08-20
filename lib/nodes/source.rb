require 'json'

module Nodes
  class Source < Struct.new(:data_dir_path)
    class << self
      def data_dir_path=(path)
        @@data_dir_path = path
      end

      def data_dir_path
        @@data_dir_path ||= './data/production'
      end
    end

    def next
      @index = @index ? @index + 1 : 0
      objects[@index] || reset_and_try_again
    end

    def matches?(other)
      self.class == other.class &&
      self.data_dir_path == other.data_dir_path
    end

    protected

    def reset_and_try_again
      @index = nil
      @current_objects = nil
      @file_index += 1
      self.next if current_file_exists?
    end

    def current_file_exists?
      File.exist?(current_file_path)
    end

    def current_file_path
      @file_index ||= 0
      "#{data_dir_path}/data/#{@file_index}.data"
    end

    def data_dir_path
      super || self.class.data_dir_path
    end

    def objects
      @current_objects ||= begin
        if current_file_exists?
          File.readlines(current_file_path)
            .map { |line| JSON.parse line }
        else
          []
        end
      end
    end
  end
end
