module MarkovTextGenerator
  class WordMap
  
    def initialize(word_tuples)
      @word_map = Hash.new
      word_tuples.each do |tuple|
        tuple_hash = tuple.reverse.inject do |last,word|
          {word => last}
        end
        current_hash = @word_map
        key = tuple_hash.keys[0]
        while current_hash[key].nil?
          break
        end
      end
    end
    
    def to_hash
      @word_map
    end
    
  end
end