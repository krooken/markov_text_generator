# 
# 
# ~~ Snowball Poem ~~
# Snowball (also called a Chaterism): A poem in which each line is a single word,
# and each successive word is one letter longer. One of the constrained writing
# techniques invented by the Oulipo (Workshop of Potential Literature).
# 
# 
# ~~ Program Description ~~
# This program takes input from the file "input-raw.txt". It examines the file for
# any word pairs which vary in length by one letter, eg. "any word", "word pairs".
# 
# To get the final Snowball poem, it starts at a one letter word ("A", "I", "O")
# and randomly traverses a Markov tree that links the second of one pair to the
# first of another if they are the same word. It then repeats this process,
# stopping when it reaches a dead branch.
# 
# 
# ~~ Features ~~
# The code scans through the input file, and examine each whitespace-separated
# word. If the word contains punctuation or numbers then it is ignored. This
# means that it also does not word pair between line breaks. This may perhaps be
# an issue with books from Project Gutenburg; as their text files are fixed width,
# we could be missing some word pairs, but it's not a big problem.
# 
# 
# ~~ Input File ~~
# The text that I used is a bunch of novels from Project Gutenburg, all collated
# into one file. Because of the prevalence of named characters, I have found it
# beneficial to remove instances of the character names, or other things that are
# specific only to the text. They look kinda rubbish when they work their way
# into Snowballs. Also, watch out for characters with lisps or phonetically
# written accents, and foreign words and phrases.
# 
# In my input file I replace all this stuff with the string "xxxxxx". The code
# then ignores any words in the input that equal this string. This could be
# automated in future by comparing each word to see if it is in a dictionary.
# 
# 
# ~~ Output Files ~~
# The program produces four output files:
# "output-wordPairsGrowing.txt" lists all word pairs, in the order that they
# appear in the input file.
# "output-followingWordsGrowing.txt" lists all word pairs as a map with each following
# word underneath. The keys are in alphabetical order.
# "output-lengthOfWordsGrowing.txt" lists all words first by length, and then by the
# order that they appear in the input file.
# "output-snowballPoems-1364561431.txt" (where the numbers are a timestamp) is the
# final output of all the created poems.
# 
# 
# ~~ Sample Snowball Output ~~
# Beware! The output will, for the most part, be absolute rubbish. But there will
# be wheat in the chaff. These are some actual unedited generated poems. The input
# was mostly Dickens.
# 
# i
# am
# but
# dust
# which
# seemed
# nothing
# whatever
# 
# o
# my
# two
# feet
# again
# walked
# through
# profound
# solemnity
# 
# i
# am
# the
# dawn
# light
# before
# anybody
# expected
# something
# disorderly
# 
# i
# do
# not
# like
# being
# hungry
# 
# 
# 
# ~~ Update 2013.04.27 ~~
# There is also a constraint called the Melting Snowball. This is pretty much what
# you'd expect it to be; it's a poem in which each line is a single word, and each
# successive word is one letter SHORTER.
# 
# Some examples:
# http://poetrywithmathematics.blogspot.co.uk/2010/11/celebrate-constraints-happy-birthday.html
# http://jacketmagazine.com/37/bury-queneau.shtml
# 
# I figured it wouldn't be too much trouble to change this code so it can generate
# these as well. I've found, though, that it tends to be much more difficult to
# find good ones. And, they pretty much all have to end in "I".
# 
# Oulipo is a French movement; apparently this stuff is easier to do in French.
# Well, I suppose that's why they call it a constraint.
# 
# 
# Some generated examples:
# 
# solitary
# brother
# always
# looks
# good
# but
# do
# i
# 
# schooling
# business
# matters
# little
# think
# boys
# and
# so
# i
# 
# shadowy
# people
# would
# kill
# you
# as
# i
# 
# 
# 
# ////////////////////////////////////////////////////////////////////////////////
# 
# #include <algorithm>
# #include <time.h>
# 
# #include <iostream>
# #include <fstream>
# #include <sstream>
# 
# #include <string>
# #include <vector>
# #include <map>
# 
# using namespace std;
# 
# Should the Pairs vector be deduped?
# bool uniqueWordPairs = true;

$uniqueWordPairs = true

# 
#     vector< vector<string> >
#     [keyWord], [followingWord]
#     {it},      {can}
#     {it},      {was}
#     {it},      {had}     
# vector< vector<string> > wordPairsGrowing;
# vector< vector<string> > wordPairsShrinking;
# vector< vector<string> > wordPairsAll;

$wordPairsGrowing = []
$wordPairsShrinking = []
$wordPairsAll = []


# 
#     map<int,vector<string> >
#     [wordLength], [wordsVector]
#     {1},          {a, i, o}
#     {2},          {it, am, to, do, we}
#     {3},          {who, are, you, may}     
# map<int,vector<string> > lengthOfWordsGrowing;
# map<int,vector<string> > lengthOfWordsShrinking;
# map<int,vector<string> > lengthOfWordsAll;

$lengthOfWordsGrowing = {}
$lengthOfWordsShrinking = {}
$lengthOfWordsAll = {}

# 
# /*  map<string,vector<string> >
#     [keyWord], [followingWordsGrowing]
#     {it},      {can, was, had}
#     {am},      {the, our}
#     {to},      {you, ask, the, put, say}     */
# map<string,vector<string> > followingWordsGrowing;
# map<string,vector<string> > followingWordsShrinking;
# map<string,vector<string> > followingWordsAll;

$followingWordsGrowing = {}
$followingWordsShrinking = {}
$followingWordsAll = {}

# 
# ////////////////////////////////////////////////////////////////////////////////
# 
# void vectorSortAndDedupe(vector< vector<string> > &inputVector) {
#   vector< vector<string> >::iterator it;
# 
#   std::sort (inputVector.begin(), inputVector.end());
#   it = std::unique (inputVector.begin(), inputVector.end());
#   inputVector.resize( std::distance(inputVector.begin(),it) );
# }

def vectorSortAndDedupe(inputVector)
  inputVector.sort!
  inputVector.uniq!
end

# 
# void vectorSaveToFile(vector< vector<string> > &inputVector, string fileName) {
#   ofstream outputFile;
#   outputFile.open(fileName.c_str());
#   for(unsigned int i=0; i < inputVector.size(); i++) {
#     for(unsigned int j=0; j < inputVector[i].size() ; j++) {
#       outputFile << inputVector[i][j] << " ";
#     } outputFile << endl;
#   }
#   outputFile.close();
# }

def vectorSaveToFile(inputVector, fileName)
  
  File.open(fileName, 'w') do |file|
    inputVector.each do |vector|
      vector.each do |word|
        file << word << " "
      end
      file << "\n"
    end
  end
  
end

# 
# void populateLengthMap(vector< vector<string> > &inputVector,
#                        map<int,vector<string> > &outputMap,
#                        string fileName) {
# 
#   for(unsigned int i=0; i < inputVector.size() - 1; i++) {
#     string firstWord = inputVector[i][0];
#     int wordLength = firstWord.length();
#     outputMap[wordLength].push_back(firstWord);
#   }
# 
#   // Print the map to a file
#   ofstream outputFile;
#   outputFile.open(fileName.c_str());
#   for(map<int,vector<string> >::iterator iterator = outputMap.begin();
#               iterator != outputMap.end();
#               iterator++) {
#     outputFile << "Key:    " << iterator->first << endl;
#     outputFile << "Values: ";
#     vector<string> wordList = iterator->second;
#     for (unsigned int i=0; i<wordList.size(); i++) {
#       outputFile << wordList[i] << endl << "        ";
#     } outputFile << endl;
#   }
#   outputFile.close();
# }

def populateLengthMap(inputVector, outputMap, fileName)
  
  inputVector.each do |vector|
    firstWord = vector[0]
    wordLength = firstWord.length
    if outputMap[wordLength]
      outputMap[wordLength] << firstWord
    else
      outputMap[wordLength] = [firstWord]
    end
  end
  
  File.open(fileName, 'w') do |file|
    outputMap.each do |key,words|
      file << "Key:    " << key << "\n"
      file << "Values: "
      words.each do |word|
        file << word << "\n" << '        '
      end
      file << "\n"
    end
  end
  
end

# 
# void populateFollowingWordsMap(vector< vector<string> > &inputVector,
#                                map<string,vector<string> > &outputMap,
#                                string fileName) {
# 
#   // Add to lengthOfWordsGrowing map
#   for(unsigned int i=0; i < inputVector.size() - 1; i++) {
#     string firstWord = inputVector[i][0];
#     outputMap[firstWord].push_back(inputVector[i][1]);
#   }
# 
#   // Print the map to a file
#   ofstream outputFile;
#   outputFile.open(fileName.c_str());
#   for(map<string,vector<string> >::iterator iterator = outputMap.begin();
#               iterator != outputMap.end();
#               iterator++) {
#     outputFile << "Key:    " << iterator->first << endl;
#     outputFile << "Values: ";
#     vector<string> wordList = iterator->second;
#     for (unsigned int i=0; i<wordList.size(); i++) {
#       outputFile << wordList[i] << endl << "        ";
#     } outputFile << endl;
#   }
#   outputFile.close();
# }

def populateFollowingWordsMap(inputVector, outputMap, fileName)

  inputVector.each do |vector|
    firstWord = vector[0]
    if outputMap[firstWord]
      outputMap[firstWord] << vector[1]
    else
      outputMap[firstWord] = [vector[1]]
    end
  end
    
  File.open(fileName, 'w') do |file|
    outputMap.each do |key,words|
      file << "Key:    " << key << "\n"
      file << "Values: "
      words.each do |word|
        file << word << "\n" << "        "
      end
      file << "\n"
    end
  end
end

# 
# ////////////////////////////////////////////////////////////////////////////////
# 
# // Normal Snowball poem creator.
# void createPoemSnowball() {
#   stringstream ss;
#   ss << "output-snowballPoems-" << time(NULL) << ".txt";
#   string fileName = ss.str();
#   ofstream outputFile;
#   outputFile.open (fileName.c_str(), fstream::app);
# 
#   // Make a thousand of them!
#   for (unsigned int i = 0; i < 1000; i++ ) {
# 
#     // string oneLetterWords[3] = {"a","i","o"};
#     string chosenWord;
#     unsigned int randIndex;
# 
#     // There are three approaches here.
#     // Choose which one to use at random.
#     unsigned int startMethod = rand() % 3 + 1;
# 
#     switch (startMethod) {
# 
#       // Select a random 1 letter word from {lengthOfWordsGrowing}
#       case 1:
#         randIndex = rand() % lengthOfWordsGrowing[1].size();
#         chosenWord = lengthOfWordsGrowing[1][randIndex];
#         outputFile << "1 " << chosenWord << endl;
#         break;
# 
#       // Just choose between one of A, I, or O
#       case 2:
#         // Cannot assume that all texts has 'a', 'i' or 'o' 
#         // followed by a two letter word
#         /*
#         randIndex = rand() % 3;
#         chosenWord = oneLetterWords[randIndex];
#         outputFile << "1 " << chosenWord << endl;
#         */
#         randIndex = rand() % lengthOfWordsGrowing[1].size();
#         chosenWord = lengthOfWordsGrowing[1][randIndex];
#         outputFile << "1 " << chosenWord << endl;
#         break;
# 
#       // Select a 2 letter word, and use "o" as the first line
#       case 3:
#         randIndex = rand() % lengthOfWordsGrowing[2].size();
#         chosenWord = lengthOfWordsGrowing[2][randIndex];
#         outputFile << "1 o" << endl;
#         outputFile << "2 " << chosenWord << endl;
#         break;
#     }
# 
#     // Find a random matching word in {followingWordsGrowing}
#     // Loop through the tree until it reaches a dead branch
#     do {
#       randIndex = rand() % followingWordsGrowing[chosenWord].size();
#       chosenWord = followingWordsGrowing[chosenWord][randIndex];
#       outputFile << chosenWord.length() << " " << chosenWord << endl;
#     } while (followingWordsGrowing[chosenWord].size() != 0);
#     outputFile << endl;
#   }
#   outputFile.close();
# }

def createPoemSnowball()
  
  fileName = "ruby-output-snowballPoems-" << Time.new.to_i.to_s << ".txt"
  File.open(fileName, 'w') do |file|
    1000.times do |i|
      chosenWord = nil
      randIndex = 0
      
      startMethod = rand(2) + 1
      
      case startMethod
      when 1
        randIndex = rand($lengthOfWordsGrowing[1].length)
        chosenWord = $lengthOfWordsGrowing[1][randIndex]
        file << "1 " << chosenWord << "\n"
        
      when 2
        randIndex = rand($lengthOfWordsGrowing[2].length)
        chosenWord = $lengthOfWordsGrowing[2][randIndex]
        file << "1 o\n"
        file << "2 " << chosenWord << "\n"
      end
      
      until $followingWordsGrowing[chosenWord].nil? do
        randIndex = rand($followingWordsGrowing[chosenWord].length)
        chosenWord = $followingWordsGrowing[chosenWord][randIndex]
        file << chosenWord.length << " " << chosenWord << "\n"
      end
      file << "\n"
    end
  end
end

# 
# ////////////////////////////////////////////////////////////////////////////////
# 
# // We need to loop through the Shrinking words backwards.
# // Save to a vector<string> buffer, and then output them forwards when it's
# //   finished and we know how long the poem will be.
# void createPoemSnowballMelting() {
#   stringstream ss;
#   ss << "output-snowballPoemsMelting-" << time(NULL) << ".txt";
#   string fileName = ss.str();
#   ofstream outputFile;
#   outputFile.open (fileName.c_str(), fstream::app);
# 
#   // Make a thousand of them!
#   for (unsigned int i = 0; i < 1000; i++ ) {
#     vector<string> currentPoem;
# 
#     // Select a random 1 letter word from {lengthOfWordsShrinking}
#     unsigned int randIndex = rand() % lengthOfWordsShrinking[1].size();
#     string chosenWord = lengthOfWordsShrinking[1][randIndex];
#     currentPoem.push_back(chosenWord);
# 
#     // Find a random matching word in {followingWordsShrinking}.
#     // Loop through the tree until it reaches a dead branch.
#     do {
#       randIndex = rand() % followingWordsShrinking[chosenWord].size();
#       chosenWord = followingWordsShrinking[chosenWord][randIndex];
#       currentPoem.push_back(chosenWord);
#     } while (followingWordsShrinking[chosenWord].size() != 0);
# 
#     // We now have the poem backwards in the {currentPoem} vector.
#     // Loop backwards through the vector and output to the file.
#     for(int i=currentPoem.size()-1 ; i >= 0; i--) {
#       outputFile << (i+1) << " " << currentPoem[i] << endl;
#     } outputFile << endl;
#   }
#   outputFile.close();
# }

def createPoemSnowballMelting()
  
  fileName = "ruby-output-snowballPoemsMelting-" << Time.now.to_i.to_s << ".txt"
  File.open(fileName, 'w') do |file|
    1000.times do
      currentPoem = []
      randIndex = rand($lengthOfWordsShrinking[1].length)
      chosenWord = $lengthOfWordsShrinking[1][randIndex]
      currentPoem << chosenWord
      
      until $followingWordsShrinking[chosenWord].nil? do
        randIndex = rand($followingWordsShrinking[chosenWord].length)
        chosenWord = $followingWordsShrinking[chosenWord][randIndex]
        currentPoem << chosenWord
      end
      
      currentPoem.reverse.each do |word|
        file << word.length << " " << word << "\n"
      end
      file << "\n"
    end
  end
end

# 
# ////////////////////////////////////////////////////////////////////////////////
# 
# // This just creates a bunch of Markov gibberish, disregarding the "one letter
# //   length difference" stuff. I don't know. I just thought it'd be interesting.
# void createRandomMarkov() {
#   stringstream ss;
#   ss << "output-randomMarkov-" << time(NULL) << ".txt";
#   string fileName = ss.str();
#   ofstream outputFile;
#   outputFile.open (fileName.c_str(), fstream::app);
# 
#   // Make a thousand of them!
#   for (unsigned int i = 0; i < 1000; i++ ) {
# 
#     // This is a fudge, because my RAND_MAX is 32767
#     unsigned int randIndex = ( rand() * rand() ) % wordPairsAll.size();
#     string chosenWord = wordPairsAll[randIndex][0];
#     outputFile << chosenWord << " ";
# 
#     // Find a random matching word in {followingWordsAll}.
#     // Loop through the tree until it reaches a dead branch  OR  we encounter a
#     //   key that only contains one value, and the value is the same as the key.
#     //   (Example: The phrase "silokwe silokwe" from Huxley's Brave New World.)
#     do {
#       randIndex = rand() % followingWordsAll[chosenWord].size();
#       chosenWord = followingWordsAll[chosenWord][randIndex];
#       outputFile << chosenWord << " ";
#     } while ( (followingWordsAll[chosenWord].size() != 0) &&
#               ( (followingWordsAll[chosenWord].size() != 1) ||
#                 (followingWordsAll[chosenWord][0] != chosenWord)
#               )
#             );
#     outputFile << endl;
#   }
#   outputFile.close();
# }

def createRandomMarkov()
  
  fileName = "ruby-output-randomMarkov-" << Time.now.to_i.to_s << ".txt"
  File.open(fileName, 'w') do |file|
    1000.times do
      randIndex = rand($wordPairsAll.length)
      chosenWord = $wordPairsAll[randIndex][0]
      file << chosenWord << " "
      
      until $followingWordsAll[chosenWord].nil? or
        ($followingWordsAll[chosenWord].length == 1 and
        $followingWordsAll[chosenWord][0] == chosenWord) do
        randIndex = rand($followingWordsAll[chosenWord].length)
        chosenWord = $followingWordsAll[chosenWord][randIndex]
        file << chosenWord << " "
      end
    end
    file << "\n"
  end
end

# 
# ////////////////////////////////////////////////////////////////////////////////
# 
# int main() {
#   srand (time(NULL));
# 
#   ofstream outputFile;
#   ifstream inputFile;
#   inputFile.open ("input-raw.txt");
# 
#   // Loop through the raw input file.
#   if (inputFile.is_open()) {
#     while ( inputFile.good() ) {
#       string previousWord;
#       string line;
#       getline (inputFile,line);
#       istringstream iss(line);
# 
#       do {
# 
#         // Examine each individual word.
#         string word;
#         iss >> word;
#         if (!word.empty()) {
# 
#           // Make the word lowercase.
#           std::transform(word.begin(), word.end(), word.begin(), ::tolower);
# 
#           // Figure out if the word contains punctuation.
#           int punctCount = 0;
#           for (string::iterator it = word.begin(); it!=word.end(); ++it)
#             if ( !isalpha(*it) )  ++punctCount;
# 
#           // If the word contains punctuation, then drop it.
#           // Also get rid of names and stuff that's specific to the input text.
#           // (So in the input file, replace "Jarndyce", "Pickwick", "Scrooge",
#           //  etc. with "xxxxxx")
#           if ( (punctCount != 0) || (word == "xxxxxx") ){
#             word = "";
# 
#           } else {
# 
#             // Add the word pair to wordPairsAll, no matter what.
#             // Also, if the lengths are separated by just one letter, add
#             //   to the approriate vector, either Growing or Shrinking.
#             if (previousWord.length() != 0) {
#               vector<string> singleWordPair;
#               singleWordPair.push_back(previousWord);
#               singleWordPair.push_back(word);
# 
#               wordPairsAll.push_back(singleWordPair);
# 
#               if (word.length() == previousWord.length()+1) {
#                 wordPairsGrowing.push_back(singleWordPair);
#               } else if (word.length()+1 == previousWord.length()) {
#                 wordPairsShrinking.push_back(singleWordPair);
#               }
#             }
#           }
#           previousWord = word;
#         }
#       } while (iss) ;
#     }
#     inputFile.close();
#   }
# 
#   // Because we'll loop through the Shrinking words backwards,
#   // we need to flip the two strings around in the vector.
#   for(unsigned int i=0; i < wordPairsShrinking.size() - 1; i++) {
#     string firstWord = wordPairsShrinking[i][0];
#     wordPairsShrinking[i][0] = wordPairsShrinking[i][1];
#     wordPairsShrinking[i][1] = firstWord;
#   }
# 
#   // Sort them and get rid of duplicates (if necessary)
#   if ($uniqueWordPairs) {
#     vectorSortAndDedupe(wordPairsGrowing);
#     vectorSortAndDedupe(wordPairsShrinking);
#     vectorSortAndDedupe(wordPairsAll);
#   }
# 
#   // Read them back out to a file
#   vectorSaveToFile(wordPairsGrowing,   "output-wordPairsGrowing.txt");
#   vectorSaveToFile(wordPairsShrinking, "output-wordPairsShrinking.txt");
#   vectorSaveToFile(wordPairsAll,       "output-wordPairsAll.txt");
# 
#   // Create the length maps
#   populateLengthMap(wordPairsGrowing,   lengthOfWordsGrowing,   "output-lengthOfWordsGrowing.txt");
#   populateLengthMap(wordPairsShrinking, lengthOfWordsShrinking, "output-lengthOfWordsShrinking.txt");
#   populateLengthMap(wordPairsAll,       lengthOfWordsAll,       "output-lengthOfWordsAll.txt");
# 
#   // Create the following words maps
#   populateFollowingWordsMap(wordPairsGrowing,   followingWordsGrowing,   "output-followingWordsGrowing.txt");
#   populateFollowingWordsMap(wordPairsShrinking, followingWordsShrinking, "output-followingWordsShrinking.txt");
#   populateFollowingWordsMap(wordPairsAll,       followingWordsAll,       "output-followingWordsAll.txt");
# 
#   // Now let's run the actual output generators
#   createPoemSnowball();
#   createPoemSnowballMelting();
#   createRandomMarkov();
# 
#   return 0;
# }

def main()

  File.open("input-raw.txt", 'r') do |file|
    file.each do |line|
      previousWord = ""
      line.scan(/\b[a-zA-Z]+\b/).each do |word|
        word.downcase!
        unless previousWord.empty?
          $wordPairsAll << [previousWord, word]
          
          $wordPairsGrowing << [previousWord, word] if previousWord.length == word.length - 1
          $wordPairsShrinking << [word, previousWord] if previousWord.length == word.length + 1
        end
        previousWord = word
      end
    end
  end
  
  if $uniqueWordPairs
    vectorSortAndDedupe($wordPairsGrowing)
    vectorSortAndDedupe($wordPairsShrinking)
    vectorSortAndDedupe($wordPairsAll)
  end
  
  vectorSaveToFile($wordPairsGrowing,   "ruby-output-wordPairsGrowing.txt")
  vectorSaveToFile($wordPairsShrinking, "ruby-output-wordPairsShrinking.txt")
  vectorSaveToFile($wordPairsAll,       "ruby-output-wordPairsAll.txt")

  # Create the length maps
  populateLengthMap($wordPairsGrowing,   $lengthOfWordsGrowing,   "ruby-output-lengthOfWordsGrowing.txt")
  populateLengthMap($wordPairsShrinking, $lengthOfWordsShrinking, "ruby-output-lengthOfWordsShrinking.txt")
  populateLengthMap($wordPairsAll,       $lengthOfWordsAll,       "ruby-output-lengthOfWordsAll.txt")

  # Create the following words maps
  populateFollowingWordsMap($wordPairsGrowing,   $followingWordsGrowing,   "ruby-output-followingWordsGrowing.txt")
  populateFollowingWordsMap($wordPairsShrinking, $followingWordsShrinking, "ruby-output-followingWordsShrinking.txt")
  populateFollowingWordsMap($wordPairsAll,       $followingWordsAll,       "ruby-output-followingWordsAll.txt")

  # Now let's run the actual output generators
  createPoemSnowball()
  createPoemSnowballMelting()
  createRandomMarkov()
end

main
