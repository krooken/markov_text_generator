require 'spec_helper'

module MarkovTextGenerator
  describe WordMap do
  
    before :each do
      input_tuples = [["a","b","c"],["a","b","d"],["b","c","d"]]
      @word_tuples = double("word_tuples")
      allow(@word_tuples).to receive(:each).and_return(input_tuples.each)
    end
    
    describe "new" do
    
      it "should call each on the word_tuples" do
        WordMap.new(@word_tuples)
        expect(@word_tuples).to have_received(:each)
      end
    
      it "should create a map within map... with the words in each tuple as keys" do
        word_map = WordMap.new(@word_tuples)
        expect(word_map.to_hash).to eq({"a"=>{"b"=>["c","d"]},"b"=>{"c"=>"d"}})
      end
  
    end
    
    describe "to_hash" do
      it "should return a hash" do
        word_map = WordMap.new(@word_tuples)
        expect(word_map.to_hash.respond_to?(:keys)).to eq(true)
      end
    end
    
  end
end