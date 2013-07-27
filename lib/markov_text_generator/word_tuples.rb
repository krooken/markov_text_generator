module MarkovTextGenerator
  class WordTuples
  
    @@default_input_file_name = "input-raw.txt"
    @@default_word_pattern = /\b[a-zA-Z]+\b/
    @@default_number_of_tuples = 6
    
    def self.scan_file(*args)
    
      input_file_name = @@default_input_file_name
      number_of_tuples = @@default_number_of_tuples
    
      args.each do |arg|
        input_file_name = arg if arg.class == String
        number_of_tuples = arg if arg.class == Fixnum
      end
      
      word_tuple = Array.new(number_of_tuples)
      
      word_tuples_all = []

      File.open(input_file_name, 'r') do |file|
        file.each do |line|
          line.scan(@@default_word_pattern).each do |word|
            word.downcase!
            word_tuple << word
            word_tuple.shift
            unless word_tuple[0].nil?
              word_tuples_all << word_tuple.clone
          
              #$wordPairsGrowing << [previousWord, word] if previousWord.length == word.length - 1
              #$wordPairsShrinking << [word, previousWord] if previousWord.length == word.length + 1
            end
          end
        end
      end
      
      WordTuples.new(word_tuples_all)
    end
    
    def initialize(word_tuples)
    
      @word_tuples = word_tuples
    
    end
    
    def each
      @word_tuples.each
    end
    
    def save_to_file(output_file_name)
      File.open(output_file_name, "w") do |file|
        @word_tuples.each do |tuple|
          file << tuple.join(" ") << "\n"
        end
      end
    end
  
  end
end