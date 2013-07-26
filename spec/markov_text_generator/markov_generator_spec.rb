require 'spec_helper'

module MarkovTextGenerator
  describe MarkovGenerator do
  
    describe "to_s" do
      it "should return a string" do
        generator = MarkovGenerator.new({"a"=>"b"})
        expect(generator.to_s.class).to eq(String)
      end
    end
    
    describe "new" do
      it "should generate a random text from the input" do
        expect(Random).to receive(:rand).and_return(0)
        generator = MarkovGenerator.new({"a"=>{"b"=>["c","d"]}})
        expect(generator.to_s).to eq("a b c")
      end
      
      it "should keep generating from the previous words" do
        allow(Random).to receive(:rand).and_return(0)
        generator = MarkovGenerator.new({"a"=>{"b"=>["c","d"]},"b"=>{"c"=>["e"]}})
        expect(generator.to_s).to eq("a b c e")
      end
    end
  
  end
end