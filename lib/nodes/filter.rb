module Nodes
  class Filter < Struct.new(:source, :filter)
    def next
      loop do
        next_row = source.next
        return nil if next_row.nil?

        matches_filter = filter.all? do |key, value|
          next_row[key.to_s] == value
        end

        return next_row if matches_filter

        next
      end
    end
  end
end
