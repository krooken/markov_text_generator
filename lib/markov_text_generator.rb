require "markov_text_generator/version"
require 'markov_text_generator/word_tuples'
require 'markov_text_generator/word_map'
require 'markov_text_generator/markov_generator'

module MarkovTextGenerator
  def self.create_random_markov(input_file_name, output_file_name, nr_of_paragraphs = 1000, tuples_length = 3)
    times = []
    times.push(Time.now.to_i)
    word_tuples = WordTuples.scan_file(input_file_name, tuples_length)
    times.push(Time.now.to_i)
    puts "Scanning took: " + (times[-1]-times[-2]).to_s + " seconds"
    word_tuples.save_to_file("ruby-output-wordPairsAll.txt")
    times.push(Time.now.to_i)
    puts "Write to file took: " + (times[-1]-times[-2]).to_s + " seconds"
    word_map = WordMap.new(word_tuples)
    times.push(Time.now.to_i)
    puts "Mapping took: " + (times[-1]-times[-2]).to_s + " seconds"
    word_map.save_to_file("ruby-output-followingWordsAll.txt")
    times.push(Time.now.to_i)
    puts "Write to file took: " + (times[-1]-times[-2]).to_s + " seconds"
    i = 0
    File.open(output_file_name + "-" + Time.now.to_i.to_s + ".txt", "w") do |file|
      nr_of_paragraphs.times do
        markov_generator = MarkovGenerator.new(word_map)
        file << markov_generator.to_s + "\n\n"
        times.push(Time.now.to_i)
        puts "Paragraph " + i.to_s + " took: " + (times[-1]-times[-2]).to_s + " seconds"
        i += 1
      end
    end
    puts "Completed in: " + (times[-1]-times[1]).to_s + " seconds"
  end
end
