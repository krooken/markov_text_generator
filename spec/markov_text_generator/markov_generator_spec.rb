require 'spec_helper'

module MarkovTextGenerator
  describe MarkovGenerator do
  
    describe "to_s" do
      it "should return a string" do
        generator = MarkovGenerator.new({"a"=>"b"})
        expect(generator.class).to eq(String)
      end
    end
    
    describe "new" do
      it "should generate a text from the input" do
        expect(Random).to receive(:rand).and_return(0)
        generator = MarkovGenerator.new({"a"=>{"b"=>["c","d"]},"b"=>{"c"=>["d"]}})
        expect(generator.to_s).to eq("a b c")
      end
    end
  
  end
end