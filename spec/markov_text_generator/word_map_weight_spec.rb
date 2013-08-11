require 'spec_helper'

module MarkovTextGenerator
  describe WordMapWeight do
  
    describe "new" do
    
      it "should create a pair with weight 1 and no word map with no given arguments" do
        expect(WordMapWeight.new.weight).to eq 1
        expect(WordMapWeight.new.map).to eq nil
      end
      
      it " should create a pair with the weight of the first argument" do
        expect(WordMapWeight.new(3).weight).to eq 3
        expect(WordMapWeight.new(3).map).to eq nil
      end
      
      it "should create a pair with the map from the second argument" do
        map = double("map")
        expect(WordMapWeight.new(3,map).weight).to eq 3
        expect(WordMapWeight.new(3,map).map).to eq map
      end
    
    end
    
    describe "weight" do
    
      it "should return the weight of the pair" do
        expect(WordMapWeight.new(5).weight).to eq 5
      end
      
    end
  
  end
end