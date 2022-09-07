RSpec.describe DeepCloneableChecked do
  describe "options_to_hash" do
    it "always returns a hash" do
      expect(DeepCloneableChecked.options_to_hash(:a)).to eq(a: [])
      expect(DeepCloneableChecked.options_to_hash({:b => :c})).to eq(b: :c)
      expect(DeepCloneableChecked.options_to_hash([:a, :b])).to eq(a: [], b: [])
      expect(DeepCloneableChecked.options_to_hash([:a, {:b => :c}, { :d => :e }])).to eq(a: [], b: :c, d: :e)
    end
  end

  describe "options_array_to_hash" do
    it "returns a hash containing all the values mapped to empty arrays" do
      expect(DeepCloneableChecked.options_array_to_hash([:a, :b])).to eq(a: [], b: [])
    end

    it "merges any values that are already hashes" do
      expect(DeepCloneableChecked.options_array_to_hash([:a, {:b => :c}, { :d => :e }])).to eq(a: [], b: :c, d: :e)
    end
  end
end