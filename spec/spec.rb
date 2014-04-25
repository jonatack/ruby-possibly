require 'possibly'

describe "possibly" do
  describe "enumerable" do
    it "#each" do
      expect { |b| Maybe::Some.new(1).each(&b) }.to yield_with_args(1)
      expect { |b| Maybe::None.new.each(&b) }.not_to yield_with_args
    end

    it "#map" do
      expect(Maybe::Some.new(2).map { |v| v * v }.get).to eql(4)
      expect { |b| Maybe::None.new.map(&b) }.not_to yield_with_args
    end

    it "#inject" do
      expect(Maybe::Some.new(2).inject(5) { |v| v * v }).to eql(25)
      expect { |b| Maybe::None.new.inject(&b) }.not_to yield_with_args
      expect(Maybe::None.new.inject(5) { }).to eql(5)
    end

    it "#select" do
      expect(Maybe::Some.new(2).select { |v| v % 2 == 0 }.get).to eql(2)
      expect(Maybe::Some.new(1).select { |v| v % 2 == 0 }.isNone).to eql(true)
    end
  end

  describe "values and non-values" do
    it "None" do
      expect(Maybe(nil).isNone).to eql(true)
      expect(Maybe([]).isNone).to eql(true)
      expect(Maybe("").isNone).to eql(true)
    end

    it "Some" do
      expect(Maybe(0).isSome).to eql(true)
      expect(Maybe(false).isSome).to eql(true)
      expect(Maybe([1]).isSome).to eql(true)
      expect(Maybe(" ").isSome).to eql(true)
    end
  end

  describe "is_a" do
    it "Some" do
      expect(Maybe::Some.new(1).is_a?(Maybe::Some)).to eql(true)
      expect(Maybe::Some.new(1).is_a?(Maybe::None)).to eql(false)
      expect(Maybe::None.new.is_a?(Maybe::Some)).to eql(false)
      expect(Maybe::None.new.is_a?(Maybe::None)).to eql(true)
      expect(Maybe::Some.new(1).is_a?(Maybe::Maybe)).to eql(true)
      expect(Maybe::None.new.is_a?(Maybe::Maybe)).to eql(true)
    end
  end

  describe "get and getOrElse" do
    it "get" do
      expect { Maybe::None.new.get }.to raise_error
      expect(Maybe::Some.new(1).get).to eql(1)
    end

    it "getOrElse" do
      expect(Maybe::None.new.getOrElse(true)).to eql(true)
      expect(Maybe::None.new.getOrElse { false }).to eql(false)
      expect(Maybe::Some.new(1).getOrElse(2)).to eql(1)
    end
  end

  describe "forward" do
    it "forwards methods" do
      expect(Maybe::Some.new("maybe").upcase.get).to eql("MAYBE")
      expect(Maybe::Some.new([1, 2, 3]).map { |arr| arr.map { |v| v * v } }.get).to eql([1, 4, 9])
    end
  end
end