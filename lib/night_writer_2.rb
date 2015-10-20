require_relative 'dictionary_tools'

class NightWriter2

  include DictionaryTools
  attr_reader :file_reader,:file

  def initialize
    @file = nil
    @reader = FileReader.new
  end

  def input
    File.read(file)
  end

  ############################################################

  #1 take input string and split it along blank spaces

  def plaintext_input_pre_process(string)
    string.split
  end

  #2 we will test array entries for whether they are special abbreviations (numbers and caps dealt with later)

  def special?(word)
    default = false
    DictionaryTool::SPECIALS.keys do |special|
      if special.to_s == word
        default = true
      end
    end

    default
  end

  #3 if a word is special we return the corresponding special hash

  def plaintext_special_to_braille_hash(word)
    special = word.sym
    braille_char = braille_num_to_hash(DictionaryTool::SPECIALS(special))
    braille_char
  end

  #4 if a word is not special we check if it is capital and process it a character a time

  def capital?(char)
    char.upcase == char
  end

  def plaintext_char_to_braille_hash(char)
    #### This method will return a shift and input letter in braille if it is capital
    letter = braille_num_to_hash(DICTIONARY[char.downcase.to_sym])
    if capital?(char)
      shift = braille_num_to_hash(DICTIONARY[:capital])
      letter = concat_braille_hashes(shift,letter)
    end
    letter
  end

  def plaintext_word_to_braille_hash(word)
    braille_word = {top: [], mid: [], bot:[]}

    word.char.each do |char|
      braille_char = plaintext_char_to_braille_hash(char)
      braille_word = concat_braille_hashes(braille_word,braille_char)
    end

    braille_word
  end

  #5 At this point we have taken all words in our input and converted them to braille hashes.
  # we have to now combine them with space characters

  def plaintext_input_to_braille_hash(string)
    braille_text = {top: [], mid: [], bot:[]}
    space = braille_num_to_hash(DictionaryTool::DICTIONARY(:" "))

    word_array = plaintext_input_pre_process(string)

    word_array.each do |word|
      if special?(word)
        braille_word = plaintext_special_to_braille_hash(word)
      else
        braille_word = plaintext_word_to_braille_hash(word)
      end
      braille_text = concat_braille_hashes(space,braille_word)
    end
    braille_text
  end

  #6 finally we print them out into a string

  def braille_hash_to_braille_string(braille_text)
    braille_string = ""
    binding.pry
    until braille_text[:top].length == 0
      writing = writing + braille_text[:top][0..79].reduce(:+) + "\n" + braille_text[:mid][0..79].reduce(:+) + "\n" + braille_text[:bot][0..79].reduce(:+) + "\n"

      braille_text[:top] = braille_text[:top][80..-1].to_a
      braille_text[:mid] = braille_text[:mid][80..-1].to_a
      braille_text[:bot] = braille_text[:bot][80..-1].to_a
    end
    braille_string
  end

  #7 Do it all in one method concat_braille_hashes

  def plaintext_input_to_braille_string(string)
    braille_text = plaintext_input_to_braille_hash(string)
    braille_string = braille_hash_to_braille_string(braille_text)
    braille_string
  end

end
