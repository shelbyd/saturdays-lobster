require 'machine_query'
require 'nodes'

describe MachineQuery do
  describe '#eval_trees' do
    subject { described_class.new(query).eval_trees }

    describe 'empty query' do
      let(:query) { {} }

      it { is_expected.to include Nodes::Source.new }
    end

    describe 'insert query' do
      let(:query) { {
        insert: {'some' => 'object'}
        } }
      it { is_expected.to include Nodes::Insert.new(query[:insert]) }
    end
  end
end
