require 'spec_helper'

describe MarkovTextGenerator::WordTuples do
  describe "scan_file" do
    before :each do
      rows = ["a b c d","e g h i"]
      File.stub(:open).and_yield(rows)
    end
  
    it "should use default file name if no argument is given" do
      File.should_receive(:open).with("input-raw.txt", "r")
      MarkovTextGenerator::WordTuples.scan_file
    end
  end
end