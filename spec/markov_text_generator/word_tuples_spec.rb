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
        pending "can't figure out how to stub Array properly"
      end
      
      it "should open the specified file, if given" do
        input_file_name = "file-name"
        expect(File).to receive(:open).with(input_file_name, "r")
        WordTuples.scan_file(input_file_name)
      end
      
      it "should use the given number of tuples, if given" do
        pending "can't figure out how to stub Array properly"
      end
      
      it "should accept two arguments" do
        input_file_name = "file-name"
        expect(File).to receive(:open).with(input_file_name, "r")
        WordTuples.scan_file(2,input_file_name)
      end
      
      it "should return an object of the class" do
        expect(WordTuples.scan_file.class).to eq(WordTuples)
      end
      
      it "should call new with an array of arrays" do
        allow(File).to receive(:open).and_yield(["a"])
        expect(WordTuples).to receive(:new).with([["a"]])
        WordTuples.scan_file(1)
      end
      
    end
    
    describe "initialize" do
      
      it "needs an array of arrays as input argument" do
        expect{WordTuples.new}.to raise_error(ArgumentError)
        expect{WordTuples.new([[]])}.to_not raise_error
      end
      
    end
    
    describe "each" do
    
      before :each do
        @input_tuples = [["a","b"],["c","d"]]
        @word_tuples = WordTuples.new(@input_tuples)
      end
    
      it "should iterate through word tuples" do
        i = 0
        @word_tuples.each do |tuple|
          expect(tuple).to eq(@input_tuples[i])
          i += 1
        end
      end
    end
    
    describe "save_to_file" do
    
      it "should save each tuple in the internal list to a separate row in the given file" do
        input_tuples = [["a","b","c"],["d","e","f"]]
        word_tuples = WordTuples.new(input_tuples)
        file = ""
        allow(File).to receive(:open).and_yield(file)
        word_tuples.save_to_file("output_file_name")
        expect(file).to eq("a b c\nd e f")
        expect(File).to have_received(:open).with("output_file_name",anyarg())
      end
      
    end
    
  end
end