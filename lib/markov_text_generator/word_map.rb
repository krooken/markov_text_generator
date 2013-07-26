module MarkovTextGenerator
  class WordMap
  
    def initialize(word_tuples)
      @word_map = Hash.new
      word_tuples.each do |tuple_list|
        tuple = tuple_list.clone
        tuple[-1] = [tuple[-1]]
        tuple_hash = tuple.reverse.inject do |last,word|
          {word => last}
        end
        current_hash = @word_map
        key = tuple_hash.keys[0]
        while tuple_hash.respond_to?(:keys) and current_hash.respond_to?(:keys) and not current_hash[key].nil?
          tuple_hash = tuple_hash[key]
          current_hash = current_hash[key]
          if tuple_hash.respond_to?(:keys)
            key = tuple_hash.keys[0]
          end
        end
        if not current_hash.respond_to?(:keys) and not tuple_hash.respond_to?(:keys)
          current_hash.push(tuple_hash).flatten!
        elsif current_hash[key].nil?
          current_hash[key] = tuple_hash[key]
        end
      end
    end
    
    def to_hash
      @word_map.clone
    end
    
  end
end