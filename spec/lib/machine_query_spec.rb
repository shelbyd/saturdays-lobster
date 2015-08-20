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

    describe 'equals query' do
      let(:query) do
        { equals: { id: 42 } }
      end

      it { is_expected.to include Nodes::Filter.new(Nodes::Source.new, {id: 42}) }
    end
  end
end
