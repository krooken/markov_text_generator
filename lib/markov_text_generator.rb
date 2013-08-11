require "markov_text_generator/version"
require 'markov_text_generator/word_tuples'
require 'markov_text_generator/word_map'
require 'markov_text_generator/markov_generator'
require 'markov_text_generator/word_map_weight'

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
    snowball_tuples = word_tuples.filter do |tuple|
      keep = true
      (tuple.length-1).times do |index|
        keep &= tuple[index].length == tuple[index+1].length-1
      end
      keep
    end
    times.push(Time.now.to_i)
    puts "Filtering tuples took: " + (times[-1]-times[-2]).to_s + " seconds"
    snowball_map = WordMap.new(snowball_tuples)
    times.push(Time.now.to_i)
    puts "Snowball mapping took: " + (times[-1]-times[-2]).to_s + " seconds"
    i = 0
    File.open(output_file_name + "-" + Time.now.to_i.to_s + ".txt", "w") do |file_markov|
      nr_of_paragraphs.times do
        markov_generator = MarkovGenerator.new(word_map)
        file_markov << markov_generator.to_s
        file_markov << "\n\n"
        times.push(Time.now.to_i)
        puts "Paragraph " + i.to_s + " took: " + (times[-1]-times[-2]).to_s + " seconds"
        i += 1
      end
    end
    File.open("ruby-output-snowballPoems" + "-" + Time.now.to_i.to_s + ".txt", "w") do |file_snowball|
      nr_of_paragraphs.times do
        snowball_generator = MarkovGenerator.new(snowball_map)
        file_snowball << snowball_generator.to_s
        file_snowball << "\n\n"
        times.push(Time.now.to_i)
        puts "Paragraph " + i.to_s + " took: " + (times[-1]-times[-2]).to_s + " seconds"
        i += 1
      end
    end
    puts "Completed in: " + (times[-1]-times[1]).to_s + " seconds"
  end
end
