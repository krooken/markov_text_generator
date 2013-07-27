require "markov_text_generator/version"
require 'markov_text_generator/word_tuples'
require 'markov_text_generator/word_map'
require 'markov_text_generator/markov_generator'

module MarkovTextGenerator
  def self.create_random_markov(input_file_name, output_file_name, nr_of_paragraphs = 1000)
    word_tuples = WordTuples.scan_file(input_file_name)
    word_tuples.save_to_file("ruby-output-wordPairsAll.txt")
    word_map = WordMap.new(word_tuples)
    word_map.save_to_file("ruby-output-followingWordsAll.txt")
    File.open(output_file_name + "-" + Time.now.to_i.to_s + ".txt", "w") do |file|
      nr_of_paragraphs.times do
        markov_generator = MarkovGenerator.new(word_map)
        file << markov_generator.to_s + "\n\n"
      end
    end
  end
end
