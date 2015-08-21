require 'machine_query'
require 'nodes'

describe MachineQuery do
  describe '#eval_trees' do
    before { allow(Indexes).to receive(:all).and_return [] }

    subject { described_class.new(query).eval_trees }

    describe 'empty query' do
      let(:query) { {} }

      it { is_expected.to include Nodes::Source.new }
    end

    describe 'unrecognized query' do
      let(:query) { {freddy: 'fazbear'} }

      it 'raises an error' do
        expect { subject }.to raise_error(ArgumentError, 'Unrecognized query')
      end
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

      context 'with an index' do
        before { allow(Indexes).to receive(:all).and_return [Nodes::Filter.new(Nodes::Source.new, {id: Variable.new})] }

        it { is_expected.to include Nodes::Index.new(0, [42]) }
      end

      context 'with two filters' do
        let(:query) do
          { equals: { id: 42, name: 'foo' } }
        end

        it { is_expected.to include Nodes::Filter.new(Nodes::Filter.new(Nodes::Source.new, {id: 42}), {name: 'foo'}) }
        it { is_expected.to include Nodes::Filter.new(Nodes::Filter.new(Nodes::Source.new, {name: 'foo'}), {id: 42}) }
      end
    end

    describe 'make fast query' do
      let(:query) do
        { make_fast: { equals: { id: 42 } } }
      end

      it { is_expected.to include Nodes::MakeFast.new([
        Nodes::Filter.new(Nodes::Source.new, {id: 42})
      ]) }
    end
  end
end
