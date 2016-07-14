require 'rom/support/auto_curry'

RSpec.describe ROM::AutoCurry do
  subject(:object) { klass.new }

  let(:klass) do
    Class.new do
      extend ROM::AutoCurry

      def self.curried(*)
        self
      end

      def initialize(*)
      end

      def arity_0
        0
      end

      def arity_1(x)
        x
      end

      def arity_2(x, y)
        [x,y]
      end

      def arity_many(*args)
        args
      end
    end
  end

  it 'registers auto-curried methods' do
    expect(object.class.auto_curried_methods).to eql(%i[arity_1 arity_2 arity_many])
  end

  it 'auto-curries method with arity == 0' do
    expect(object.arity_0).to be(0)
  end

  it 'auto-curries method with arity == 1' do
    expect(object.arity_1).to be_instance_of(klass)
    expect(object.arity_1(1)).to be(1)
  end

  it 'auto-curries method with arity > 0' do
    expect(object.arity_2).to be_instance_of(klass)
    expect(object.arity_2(1, 2)).to eql([1, 2])
  end

  it 'auto-curries method with arity < 0' do
    expect(object.arity_many).to eql([])
    expect(object.arity_many(1, 2)).to eql([1, 2])
  end
end
