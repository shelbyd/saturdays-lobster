require 'nodes/source'
require 'json'

describe Nodes::Source do
  let(:objects) { [] }
  let(:file_contents) { objects.map(&:to_json).join("\n") }
  let(:data_dir) { './data' }

  before { Dir.mkdir(data_dir) unless File.directory?(data_dir) }
  before { File.open("#{data_dir}/data.data", 'w') { |f| f.write(file_contents) } }

  describe '#next' do
    subject { described_class.new(data_dir).next }

    context 'with no data' do
      it { is_expected.to eq nil }
    end

    context 'with one object' do
      let(:objects) { [{'foo' => 'bar'}] }

      it { is_expected.to eq objects[0] }
    end
  end
end
