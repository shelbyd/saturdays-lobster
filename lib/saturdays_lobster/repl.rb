module SaturdaysLobster
  class Repl
    attr_reader :input,
                :output

    def initialize(input, output)
      self.input = input
      self.output = output
    end

    def loop
      prompt
      while gotten = input.gets
        output.puts gotten
        prompt
      end
    end

    def prompt
      output.print 'saturdays_lobster=# '
    end

    private

    attr_writer :input,
                :output
  end
end
