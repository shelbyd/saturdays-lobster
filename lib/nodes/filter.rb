require 'variable'

module Nodes
  class Filter < Struct.new(:source, :filter)
    def next
      loop do
        next_row = source.next
        return nil if next_row.nil?

        matches_filter = filter.all? do |key, value|
          value == next_row[key.to_s]
        end

        return next_row if matches_filter

        next
      end
    end

    def variables
      filter.values.select(&:variable?)
    end

    def matches?(tree)
      tree.class == self.class &&
      filter.all? do |key, value|
        value == tree.filter[key]
      end &&
      tree.filter.all? do |key, value|
        value == filter[key]
      end &&
      source.matches?(tree.source)
    end
  end
end
