require 'spec_helper'

describe SaturdaysLobster::Node do
  describe '.from_syntax_tree' do
    subject { described_class.from_syntax_tree(NodeParser.new.parse(node)) }

    describe '()' do
      let(:node) { '()' }

      it 'has no labels' do
        expect(subject.labels).to eq []
      end

      it 'has no properties' do
        expect(subject.properties).to eq({})
      end

      it 'has id 1' do
        expect(subject.id).to eq(1)
      end
    end

    describe '(:Movie)' do
      let(:node) { '(:Movie)' }

      it 'has the label Movie' do
        expect(subject.labels).to eq [:Movie]
      end

      it 'has no properties' do
        expect(subject.properties).to eq({})
      end

      it 'has id 1' do
        expect(subject.id).to eq(1)
      end
    end

    describe '(:Movie)' do
      let(:node) { '(:Movie)' }

      it 'has the label Movie' do
        expect(subject.labels).to eq [:Movie]
      end

      it 'has no properties' do
        expect(subject.properties).to eq({})
      end

      it 'has id 1' do
        expect(subject.id).to eq(1)
      end
    end

    describe '({ released_in: 1991})' do
      let(:node) { '({ released_in: 1991})' }

      it 'has the no labels' do
        expect(subject.labels).to eq []
      end

      it 'has the property released_in' do
        expect(subject.properties).to eq({released_in: 1991})
      end

      it 'has id 1' do
        expect(subject.id).to eq(1)
      end
    end

    describe '({ released_in: "Canada"})' do
      let(:node) { '({ released_in: "Canada"})' }

      it 'has the property released_in' do
        expect(subject.properties).to eq({released_in: "Canada"})
      end
    end

    describe '({ float: 5.124 })' do
      let(:node) { '({ float: 5.124 })' }

      it 'has the property released_in' do
        expect(subject.properties).to eq({float: 5.124})
      end
    end
  end
end
