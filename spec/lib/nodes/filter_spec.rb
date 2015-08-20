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

  describe '#matches' do
    let(:source) { double :source, matches?: true }
    let(:filter) { {} }
    let(:other_source) { source }
    let(:other_filter) { filter }
    let(:other) { described_class.new(other_source, other_filter) }
    let(:this) { described_class.new(source, filter) }

    subject { this.matches? other }

    context 'with itself' do
      it { is_expected.to be true }
    end

    context 'when self has a field other does not' do
      let(:filter) { {id: 15} }
      let(:other_filter) { {} }

      it { is_expected.to be false }
    end

    context 'when other has a filter self does not' do
      let(:filter) { {} }
      let(:other_filter) { {id: 15} }

      it { is_expected.to be false }
    end

    context 'with a variable in self' do
      let(:filter) { {id: Variable.new} }
      let(:other_filter) { {id: 15} }

      it { is_expected.to be true }

      it 'stores the value from the other filter' do
        subject

        expect(this.variables.first.values).to eq [15]
      end
    end

    context 'with a variable in self' do
      let(:filter) { {id: 15} }
      let(:other_filter) { {id: Variable.new} }

      it { is_expected.to be true }

      it 'stores the value from the other filter' do
        subject

        expect(other.variables.first.values).to eq [15]
      end
    end
  end
end
