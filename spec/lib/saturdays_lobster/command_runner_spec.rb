require 'spec_helper'

describe SaturdaysLobster::CommandRunner do
  describe '#run' do
    subject { described_class.new(command).run }

    describe 'CREATE ()' do
      let(:command) { 'CREATE ()' }
      it { is_expected.to include 'Nodes created: 1' }
      it { is_expected.to include 'Properties set: 0' }
      it { is_expected.to include 'Labels added: 0' }
    end

    describe 'create ()' do
      let(:command) { 'create ()' }
      it { is_expected.to include 'Nodes created: 1' }
    end

    describe 'CREATE (:Movie)' do
      let(:command) { 'CREATE (:Movie)' }
      it { is_expected.to include 'Labels added: 1' }
    end

    describe 'CREATE (:Movie:Actable)' do
      let(:command) { 'CREATE (:Movie:Actable)' }
      it { is_expected.to include 'Labels added: 2' }
    end

    describe 'CREATE ({ foo: "bar" })' do
      let(:command) { 'CREATE ({ foo: "bar" })' }
      it { is_expected.to include 'Properties set: 1' }
    end

    describe 'CREATE ({ foo: "bar", bar: 1234567 })' do
      let(:command) { 'CREATE ({ foo: "bar", bar: 1234567 })' }
      it { is_expected.to include 'Properties set: 2' }
    end
  end
end
