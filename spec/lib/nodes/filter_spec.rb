require 'nodes/filter'

describe Nodes::Filter do
  describe '#next' do
    let(:source) { double(:source) }
    let(:filter) { {id: 15} }
    let(:call_count) { 0 }

    let(:objects) { [] }
    before { allow(source).to receive(:next).and_return(*objects, nil) }

    let(:node) { described_class.new(source, filter) }
    subject { call_count.times { node.next }; node.next }

    context 'with an empty source' do
      it { is_expected.to be_nil }
    end

    context 'with a source with a node that matches the filter' do
      let(:objects) { [{'id' => 15}] }

      it { is_expected.to eq objects[0] }

      context 'after being called once' do
        let(:call_count) { 1 }

        it { is_expected.to be_nil }
      end
    end

    context 'with a source with a node that does not match the filter' do
      let(:objects) { [{'id' => 16}] }

      it { is_expected.to be_nil }
    end

    context 'with a variable' do
      let(:objects) { [{'id' => 16}] }
      let(:filter) { {id: Variable.new} }

      it { is_expected.to eq objects[0] }

      it 'sets the value for the variable' do
        subject

        expect(node.variables.first.values).to eq [16]
      end
    end
  end
end
