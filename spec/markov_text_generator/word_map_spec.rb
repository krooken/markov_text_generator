require 'spec_helper'

module MarkovTextGenerator
  describe WordMap do
  
    before :each do
      @input_tuples = [["a","b","c"],["a","b","d"],["b","c","d"]]
      @word_tuples = double("word_tuples")
      allow(@word_tuples).to receive(:each).and_yield(@input_tuples)
    end
    
    describe "new" do
    
      it "should call each on the word_tuples" do
        WordMap.new(@word_tuples)
        expect(@word_tuples).to have_received(:each)
      end
    
      it "should create a map within map... with the words in each tuple as keys" do
        word_map = WordMap.new(@input_tuples)
        expect(word_map.to_hash).to eq({"a"=>{"b"=>["c","d"]},"b"=>{"c"=>["d"]}})
      end
  
    end
    
    describe "to_hash" do
      it "should return a hash" do
        word_map = WordMap.new(@word_tuples)
        expect(word_map.to_hash.respond_to?(:keys)).to eq(true)
      end
    end
    
    describe "save_to_file" do
    
      it "should save the tree of keys and values" do
        word_map = WordMap.new(@input_tuples)
        file = ""
        allow(File).to receive(:open).and_yield(file)
        word_map.save_to_file("output_file_name")
        expect(file).to eq("a b c\n    d\n\nb c d\n\n")
        expect(File).to have_received(:open).with("output_file_name",anything())
      end
      
    end
    
    describe "print_hash" do
      
      it "should print an array with indent" do
        word_map = WordMap.new(@word_tuples)
        file = "  "
        word_map.print_hash(["a","b","c"],file,"  ")
        expect(file).to eq("  a\n  b\n  c\n\n")
      end
      
      it "should print a hash to a row" do
        word_map = WordMap.new(@word_tuples)
        file = ""
        word_map.print_hash({"a"=>["b"]},file,"")
        expect(file).to eq("a b\n\n")
      end
      
      it "should print several values to several rows" do
        word_map = WordMap.new(@word_tuples)
        file = ""
        word_map.print_hash({"a"=>["b","c"]},file,"")
        expect(file).to eq("a b\n  c\n\n")
      end
      
      it "should print a hash within a hash to one row" do
        word_map = WordMap.new(@word_tuples)
        file = ""
        word_map.print_hash({"a"=>{"b"=>["c"]}},file,"")
        expect(file).to eq("a b c\n\n")
      end
      
      it "should print several values within hashes to several rows" do
        word_map = WordMap.new(@word_tuples)
        file = ""
        word_map.print_hash({"a"=>{"b"=>["c","d"]},"b"=>{"c"=>["d"]}},file,"")
        expect(file).to eq("a b c\n    d\n\nb c d\n\n")
      end
      
    end
    
  end
end