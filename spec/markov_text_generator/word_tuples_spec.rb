require 'spec_helper'

module MarkovTextGenerator
  describe WordTuples do
    describe "scan_file" do
      before :each do
        rows = ["a b c d","e g h i"]
        allow(File).to receive(:open).and_yield(rows)
      end
  
      it "should use default file name if no argument is given" do
        expect(File).to receive(:open).with("input-raw.txt", "r")
        WordTuples.scan_file
      end
      
      it "should use default number of tuples if no argument is given" do
        default_tuples = 6
        array = Array.new(default_tuples)
        Array.should_receive(:new).with(6).and_return(array)
        WordTuples.scan_file
      end
    end
  end
end