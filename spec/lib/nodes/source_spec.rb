require 'nodes/source'

describe Nodes::Source do
  let(:objects) { [] }
  let(:file_contents) { objects.map(&:to_json).join("\n") }
  let(:data_dir) { './data/test' }
  let(:raw_data_dir) { "#{data_dir}/data" }

  after { FileUtils.rmtree(data_dir) }

  before { FileUtils.mkdir_p(raw_data_dir) }
  before { File.open("#{raw_data_dir}/0.data", 'w') { |f| f.write(file_contents) } }

  describe '#next' do
    let(:node) { described_class.new(data_dir) }
    let(:call_count) { 0 }
    subject { call_count.times { node.next }; node.next }

    context 'with no data' do
      before { FileUtils.rmtree(data_dir) }
      it { is_expected.to eq nil }
    end

    context 'with one object' do
      let(:objects) { [{'foo' => 'bar'}] }

      it { is_expected.to eq objects[0] }

      context 'after being called once' do
        let(:call_count) { 1 }

        it { is_expected.to be_nil }
      end
    end

    context 'with three objects' do
      let(:objects) { [
        {'foo' => 'foo'},
        {'bar' => 'bar'},
        {'baz' => 'baz'},
      ] }

      it { is_expected.to eq objects[0] }

      context 'after being called once' do
        let(:call_count) { 1 }
        it { is_expected.to eq objects[1] }
      end

      context 'after being called twice' do
        let(:call_count) { 2 }
        it { is_expected.to eq objects[2] }
      end

      context 'after being called three times' do
        let(:call_count) { 3 }
        it { is_expected.to be_nil }
      end
    end

    context 'with data split up across three files' do
      let(:objects0) { [
        {'foo0' => 'foo0'},
        {'bar0' => 'bar0'},
        {'baz0' => 'baz0'},
      ] }
      let(:objects1) { [
        {'foo1' => 'foo1'},
        {'bar1' => 'bar1'},
        {'baz1' => 'baz1'},
      ] }
      let(:objects2) { [
        {'foo2' => 'foo2'},
        {'bar2' => 'bar2'},
        {'baz2' => 'baz2'},
      ] }

      before do
        [objects0, objects1, objects2].each_with_index do |objects, index|
          File.open("#{raw_data_dir}/#{index}.data", 'w') do |f|
            f.write objects.map(&:to_json).join("\n")
          end
        end
      end

      it { is_expected.to eq objects0[0] }

      context 'after being called three times' do
        let(:call_count) { 3 }
        it { is_expected.to eq objects1[0] }
      end

      context 'after being called six times' do
        let(:call_count) { 6 }
        it { is_expected.to eq objects2[0] }
      end

      context 'after being called eight times' do
        let(:call_count) { 8 }
        it { is_expected.to eq objects2[2] }
      end

      context 'after being called nine times' do
        let(:call_count) { 9 }
        it { is_expected.to be_nil }
      end
    end
  end
end
