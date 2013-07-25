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
    
      it "should create a map with the first word in each tuple as key" do
        WordMap.new(@word_tuples)
        pending
      end
  
    end
  end
end