require 'nodes/make_fast'

describe Nodes::MakeFast do
  describe '#next' do
    let(:tree) { double :tree }
    let(:possible_trees) { [tree] }
    let(:rows) { [] }
    let(:data_path) { './data/test' }
    let(:variable) { double :variable }

    before { FileUtils.rmtree('./data/test') }

    before { allow(tree).to receive(:next).and_return(*rows, nil) }
    before { allow(tree).to receive(:variables).and_return [variable] }

    around do |example|
      stored_path = Nodes::MakeFast.data_path
      Nodes::MakeFast.data_path = data_path
      example.run
      Nodes::MakeFast.data_path = stored_path
    end

    subject { described_class.new(possible_trees) }

    it 'writes the tree structure' do
      subject.next

      expect(YAML.load(File.read('./data/test/index/all.index'))).to be_one
    end

    context 'with no rows' do
      it 'does not write anything to its index' do
        subject.next

        expect(Dir['./data/test/index/0/*.index'].count { |f| File.file? f }).to be_zero
      end
    end

    context 'with one row' do
      let(:rows) { [{'id' => 50}] }

      before { allow(variable).to receive(:values).and_return [50] }

      it 'writes the row to an index' do
        subject.next

        expect(File.read('./data/test/index/0/50.index')).to include rows[0].to_json
      end
    end

    context 'with three rows' do
      let(:rows) { [{'id' => 50}, {'id' => 12}, {'id' => 3}, ] }

      before { allow(variable).to receive(:values).and_return([50], [12], [3]) }

      it 'writes the first row to an index' do
        subject.next

        expect(File.read('./data/test/index/0/50.index')).to include rows[0].to_json
      end

      it 'writes the second row to an index' do
        subject.next

        expect(File.read('./data/test/index/0/12.index')).to include rows[1].to_json
      end

      it 'writes the third row to an index' do
        subject.next

        expect(File.read('./data/test/index/0/3.index')).to include rows[2].to_json
      end
    end
  end
end
