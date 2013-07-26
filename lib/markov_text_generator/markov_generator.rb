module MarkovTextGenerator
  class MarkovGenerator
  
    def initialize(word_map)
      chosen_words = []
      current_hash = word_map.to_hash
      while current_hash.respond_to?(:keys)
        rand_index = Random.rand(current_hash.keys.length)
        chosen_word = current_hash.keys[rand_index]
        chosen_words.push(chosen_word)
        current_hash = current_hash[chosen_word]
      end
      word_array = current_hash
      generated_text = chosen_words.clone
      until word_array.nil? or (word_array.length == 1 and chosen_words[-1] == word_array[0])
        rand_index = Random.rand(word_array.length)
        chosen_word = word_array[rand_index]
        chosen_words.push(chosen_word).shift
        generated_text.push(chosen_word)
        current_hash = word_map.to_hash
        hash_index = 0
        while current_hash.respond_to?(:keys)
          chosen_word = chosen_words[hash_index]
          current_hash = current_hash[chosen_word]
          hash_index += 1
        end
        word_array = current_hash
      end
      @markov_text = generated_text.clone
    end
    
    def to_s
      @markov_text.join(" ")
    end
  
  end
end