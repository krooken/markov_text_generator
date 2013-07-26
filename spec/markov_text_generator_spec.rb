module MarkovTextGenerator

  describe MarkovTextGenerator do
    describe "create_random_markov" do
    
      before :each do
        @input_file = [["a"],["b"]]
        @output_file = ""
        allow(File).to receive(:open).and_yield(@input_file,@output_file)
      end
    
      it "should require a input filename and output file prefix" do
        expect{MarkovTextGenerator.create_random_markov("input_file_name","output_file_prefix")}.to_not raise_error
        expect{MarkovTextGenerator.create_random_markov("input_file_name")}.to raise_error
        expect{MarkovTextGenerator.create_random_markov("output_file_prefix")}.to raise_error
        expect{MarkovTextGenerator.create_random_markov(1000,4)}.to raise_error
      end
      
      it "should allow an optional fixnum as argument" do
        expect{MarkovTextGenerator.create_random_markov("input_file_name","output_file_prefix",1)}.to_not raise_error
      end
      
      it "should scan the input file" do
        input_file_name = "input_file_name"
        expect(WordTuples).to receive(:scan_file) do |args|
          expect(args.include?(input_file_name)).to eq true
        end
        text_generator = MarkovTextGenerator.create_random_markov(input_file_name,"output_file_prefix")
      end
      
      it "should create a word map from the scanned file contents" do
        input_tuples = [["a","b"],["b","c"]]
        allow(WordTuples).to receive(:new).and_return(input_tuples)
        expect(WordMap).to receive(:new).with(input_tuples)
        MarkovTextGenerator.create_random_markov("input_file_name","output_file_prefix")
      end
      
      it "should create a markov generator from the word map" do
        input_hash = {"a"=>["b"],"b"=>["c"]}
        allow(WordMap).to receive(:new).and_return(input_hash)
        expect(MarkovGenerator).to receive(:new).with(input_hash)
        MarkovTextGenerator.create_random_markov("input_file_name","output_file_prefix")
      end
      
      it "should write the given number of paragraphs to the output file" do
        number_of_pars = 10
        markov_generator = double("markov_generator")
        allow(MarkovGenerator.new).to receive(:new).and_return(markov_generator)
        expect(markov_generator).to receive(:to_s).exactly(number_of_pars).times.and_return("a")
        MarkovTextGenerator.create_random_markov("input_file_name","output_file_prefix",number_of_pars)
        expect(@output_file).to eq("a\na\na\na\na\na\na\na\na\na\n")
      end
      
      it "should append a string based on current time, and '.txt' to the output file" do
        pending
      end
      
    end
  end
end