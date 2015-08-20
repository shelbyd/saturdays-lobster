require 'nodes/insert'

describe Nodes::Insert do
  describe '#next' do
    let(:data_path) { './data/test/data' }
    let(:max_size) { 256 }
    let(:row) { {'some' => 'data'} }

    subject { described_class.new(row) }

    before { FileUtils.rmtree data_path }
    before { FileUtils.mkdir_p data_path }

    around do |example|
      stored_path = Nodes::Insert.data_path
      stored_size = Nodes::Insert.max_size
      Nodes::Insert.data_path = data_path
      Nodes::Insert.max_size = max_size
      example.run
      Nodes::Insert.data_path = stored_path
      Nodes::Insert.max_size = stored_size
    end

    describe 'with no data' do
      it 'writes the row to data 0' do
        subject.next

        expect(File.read("#{data_path}/0.data")).to eq row.to_json + "\n"
      end
    end

    describe 'with 1 row' do
      before do
        File.open("#{data_path}/0.data", 'w') do |f|
          f.write('{"foo": "bar"}' + "\n")
        end
      end

      it 'appends the new row to data 0' do
        subject.next

        expect(File.read("#{data_path}/0.data")).to end_with row.to_json + "\n"
      end

      it 'keeps the old data' do
        subject.next

        expect(File.read("#{data_path}/0.data")).to include "{\"foo\": \"bar\"}\n"
      end
    end

    describe 'with a full first file' do
      before do
        while File.size?("#{data_path}/0.data").to_i < max_size
          File.open("#{data_path}/0.data", 'a') do |f|
            f.write('{"foo": "bar"}' + "\n")
          end
        end
      end

      it 'writes to the second file' do
        subject.next

        expect(File.read("#{data_path}/1.data")).to end_with row.to_json + "\n"
      end
    end
  end
end
