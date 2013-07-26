require 'spec_helper'

module MarkovTextGenerator
  describe MarkovGenerator do
  
    before :each do
      @word_map = double("word_map")
    end
  
    describe "to_s" do
      it "should return a string" do
        allow(@word_map).to receive(:to_hash).and_return({"a"=>"b"})
        generator = MarkovGenerator.new(@word_map)
        expect(generator.to_s.class).to eq(String)
      end
    end
    
    describe "new" do
      it "should generate a random text from the input" do
        allow(@word_map).to receive(:to_hash).and_return({"a"=>{"b"=>["c","d"]}})
        expect(Random).to receive(:rand).and_return(0)
        generator = MarkovGenerator.new(@word_map)
        expect(generator.to_s).to eq("a b c")
      end
      
      it "should keep generating from the previous words" do
        allow(@word_map).to receive(:to_hash).and_return({"a"=>{"b"=>["c","d"]},"b"=>{"c"=>["e"]}})
        allow(Random).to receive(:rand).and_return(0)
        generator = MarkovGenerator.new(@word_map)
        expect(generator.to_s).to eq("a b c e")
      end
    end
  
  end
end