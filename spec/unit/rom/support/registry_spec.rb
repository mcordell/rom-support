require 'spec_helper'
require 'rom/support/registry'

shared_examples_for 'registry fetch' do
  it 'returns registered element identified by name' do
    expect(registry.public_send(fetch_method, :mars)).to be(mars)
  end

  it 'raises error when element is not found' do
    expect { registry.public_send(fetch_method, :twix) }.to raise_error(
      ROM::Registry::ElementNotFoundError,
      ":twix doesn't exist in Candy registry"
    )
  end

  it 'returns the value from an optional block when key is not found' do
    value = registry.public_send(fetch_method, :candy) { :twix }

    expect(value).to eq(:twix)
  end

  it 'calls #to_sym on a key before fetching' do
    expect(registry.public_send(fetch_method, double(to_sym: :mars))).to be(mars)
  end
end

describe ROM::Registry do
  subject(:registry) { registry_class.new(mars: mars) }

  let(:mars) { double('mars') }

  let(:registry_class) do
    Class.new(ROM::Registry) do
      def self.name
        'Candy'
      end
    end
  end

  describe '#fetch' do
    let(:fetch_method) { :fetch }

    it_behaves_like 'registry fetch'
  end

  describe '#[]' do
    let(:fetch_method) { :[] }

    it_behaves_like 'registry fetch'
  end

  describe '#method_missing' do
    it 'returns registered element identified by name' do
      expect(registry.mars).to be(mars)
    end

    it 'raises no-method error when element is not there' do
      expect { registry.twix }.to raise_error(NoMethodError)
    end
  end
end
