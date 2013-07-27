module MarkovTextGenerator

  describe MarkovTextGenerator do
    describe "create_random_markov" do
    
      before :each do
        @input_file = ["a","b"]
        @output_file = ""
        allow(File).to receive(:open).and_yield(@output_file)
        @input_tuples = [["a","b"],["b","c"]]
        #allow(WordTuples).to receive(:new).and_return(input_tuples)
        allow(WordTuples).to receive(:scan_file).and_return(@input_tuples)
        @input_hash = {"a"=>["b"],"b"=>["c"]}
        allow(WordMap).to receive(:new).and_return(@input_hash)
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
        text_generator = MarkovTextGenerator.create_random_markov(input_file_name,"output_file_prefix")
        expect(WordTuples).to have_received(:scan_file) do |args|
          expect(args.include?(input_file_name)).to eq true
        end
      end
      
      it "should create a word map from the scanned file contents" do
        expect(WordMap).to receive(:new).with(@input_tuples)
        MarkovTextGenerator.create_random_markov("input_file_name","output_file_prefix")
      end
      
      it "should create a markov generator from the word map" do
        expect(MarkovGenerator).to receive(:new).with(@input_hash).at_least(:once)
        MarkovTextGenerator.create_random_markov("input_file_name","output_file_prefix")
      end
      
      it "should write the given number of paragraphs to the output file" do
        number_of_pars = 10
        markov_generator = double("markov_generator")
        allow(MarkovGenerator).to receive(:new).and_return(markov_generator)
        expect(markov_generator).to receive(:to_s).exactly(number_of_pars).times.and_return("a")
        MarkovTextGenerator.create_random_markov("input_file_name","output_file_prefix",number_of_pars)
        expect(@output_file).to eq("a\n\na\n\na\n\na\n\na\n\na\n\na\n\na\n\na\n\na\n\n")
      end
      
      it "should append a string based on current time, and '.txt' to the output file" do
        time = Time.new(2000,07,25,12,54,32)
        expect(Time).to receive(:now).and_return(time)
        MarkovTextGenerator.create_random_markov("input_file_name","output_file_prefix")
        expect(File).to have_received(:open).with("output_file_prefix" + "-" + time.to_i.to_s + ".txt", anything()).at_least(:once)
      end
      
      it "should print word tuples to a file" do
        expect(@input_tuples).to receive(:save_to_file).with("ruby-output-wordPairsAll.txt")
        MarkovTextGenerator.create_random_markov("input_file_name","output_file_name")
      end
      
      it "should print word map to a file" do
        expect(@input_hash).to receive(:save_to_file).with("ruby-output-followingWordsAll.txt")
        MarkovTextGenerator.create_random_markov("input_file_name","output_file_name")
      end
      
    end
  end
end