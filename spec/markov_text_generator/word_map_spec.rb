require 'spec_helper'

module MarkovTextGenerator
  describe WordMap do
  
    before :each do
      rows = ["a b b", "b g"]
      allow(File).to receive(:open).and_yield(rows)
      @input_tuples = [["a","b","c"],["b","c","d"],["c","d","g"]]
      #@word_tuples = double("word_tuples")
      @word_tuples = WordTuples.scan_file
      #allow(@word_tuples).to receive(:each).and_return(@input_tuples.each)
    end
    
    describe "new" do
    
      it "should call each on the word_tuples" do
        expect(@word_tuples).to receive(:each).and_call_original
        WordMap.new(@word_tuples)
      end
    
      it "should create a map within map... with the words in each tuple as keys" do
        word_map = WordMap.new(@word_tuples)
        expect(word_map.to_hash).to eq({"a"=>{"b"=>["b"]},"b"=>{"b"=>["b","g"]}})
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
        word_map = WordMap.new(@word_tuples)
        file = ""
        allow(File).to receive(:open).and_yield(file)
        word_map.save_to_file("output_file_name")
        expect(file).to eq("a b b\n\nb b b\n    g\n\n")
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
    
    describe "add" do
      
      it "should add the first element as key" do
        pending
      end
      
      it "should create a new WordMap" do
        pending
      end
      
    end
    
    describe "[]" do
    
      it "should return the WordMap corresponding to the given key" do
        pending
      end
      
      it "should raise an exception if the key doesn't exist" do
        word_map = WordMap.new(@word_tuples)
        expect{word_map["q"]}.to raise_error(ArgumentError)
      end
      
    end
    
  end
end