require 'nodes/index'

describe Nodes::Index do
  let(:node) { described_class.new(id, values) }
  let(:data_path) { './data/test' }

  let(:id) { 0 }
  let(:values) { [1] }
  let(:rows) { [] }

  after { FileUtils.rmtree(data_path) }
  before do
    next if rows.empty?

    index_file = "#{data_path}/index/#{id}/#{values.first}.index"
    FileUtils.mkdir_p(File.dirname(index_file))
    FileUtils.touch(index_file)
    File.open(index_file, 'w') { |f| rows.each { |row| f.puts row.to_json } }
  end

  around do |example|
    stored_path = Nodes::Index.data_path
    Nodes::Index.data_path = data_path
    example.run
    Nodes::Index.data_path = stored_path
  end

  describe '#next' do
    let(:call_count) { 0 }

    subject { call_count.times { node.next }; node.next }

    context 'without a file' do
      let(:values) { [-1] }

      it { is_expected.to be_nil }
    end

    context 'with one row' do
      let(:rows) { [{'age' => 1}] }

      it { is_expected.to eq rows[0] }

      context 'after being called once' do
        let(:call_count) { 1 }

        it { is_expected.to be_nil }
      end
    end
  end

  describe '#execution_time' do
    subject { node.execution_time }

    context 'with no rows' do
      it { is_expected.to eq 0 }
    end

    context 'with 3 rows' do
      let(:rows) { 3.times.map { {} } }

      it { is_expected.to eq 3 }
    end
  end
end
