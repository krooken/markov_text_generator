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
    
    def save_to_file(output_file_name)
      indent = ""
      File.open(output_file_name, "w") do |file|
        print_hash(@word_map, file, indent)
      end
    end
    
    def print_hash(hash, file, indent)
      if not hash.respond_to?(:each_key)
        first = true
        hash.each do |value|
          if first
            file << value.to_s << "\n"
            first = false
          else
            file << indent << value.to_s << "\n"
          end
        end
        file << "\n"
      else
        first = true
        hash.each_key do |key|
          if first
            first = false
          else
            file << indent
          end
          file << key.to_s
          file << " "
          print_hash(hash[key], file, indent + "  ")
        end
      end
    end
    
  end
end