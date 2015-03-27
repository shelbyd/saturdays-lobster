module SaturdaysLobster
  class CommandRunner < Struct.new(:command)
    def run
      [
        'Nodes created: 1',
        'Properties set: 2',
        'Labels added: 1',
      ].join("\n")
    end
  end
end
