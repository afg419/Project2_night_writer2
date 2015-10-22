require_relative 'dictionary_tools'
require_relative 'file_reader_writer'
require_relative 'night_reader_2'
require 'pry'

class NightWriter2

  include DictionaryTools
  attr_reader :file_reader,:file

  def initialize

  end

  def input
    File.read(file)
  end

  ############################################################

  #1 take input string and split it along blank spaces. we process word by word

  def plaintext_to_words(string)
    string.split
  end

  #2 we will test array entries for whether they are special abbreviations (numbers and caps dealt with later)

  def special?(word)
    default = false

    SPECIALS.keys.each do |special|
      if special == word.to_sym
        default = true
      end
    end

    default
  end

  #3 if a word is special we return the corresponding special braille character, found in SPECIALS dictionary.

  def plaintext_special_to_braille_char(word)
    special = word.to_sym
    braille_char = braille_num_to_hash(SPECIALS[special])
    braille_char
  end

  #4 if a word is not special we check if it is capital or a number and process them a character at a time
  # if it is a number, it is processed throught the NUMBERS dictionary, otherwise through the DICTIONARY.

  def capital?(char)
    char.upcase == char
  end

  def number?(word)
    word.chr.to_i.to_s == word.chr
  end

  def plaintext_char_to_braille_char(char)
    #### This method will return a shift and input letter in braille if it is capital
    letter = braille_num_to_hash(DICTIONARY[char.downcase.to_sym])
    if capital?(char)
      shift = braille_num_to_hash(DICTIONARY[:_])
      letter = concat_braille_hashes(shift,letter)
    end
    letter
  end

  def plaintext_word_to_braille_word(word)
    braille_word = {top: [], mid: [], bot:[]}

    word.chars.each do |char|
      braille_char = plaintext_char_to_braille_char(char)
      braille_word = concat_braille_hashes(braille_word,braille_char)
    end

    braille_word
  end

  def plaintext_digit_to_braille_digit(digit)
    braille_digit = braille_num_to_hash(NUMBERS[digit])
    braille_digit
  end

  def plaintext_number_to_braille_number(word)
    braille_word = braille_num_to_hash(NUMBERS['#'])
    word.chars.each do |digit|
      braille_digit = plaintext_digit_to_braille_digit(digit)
      braille_word = concat_braille_hashes(braille_word,braille_digit)
    end
    braille_word
  end

  #5 At this point we have taken all words in our input and converted them to braille hashes.
  # we have to now combine them along with the space characters we removed in pre_processing

  def plaintext_text_to_braille_text(string)
    # what is the input
    # what is the end result
      # list out steps
      # each step becomes a unit test
      # the implementation is the integration test


    braille_text = {top: [], mid: [], bot:[]}
    space = braille_num_to_hash(DICTIONARY[:" "])

    word_array = plaintext_to_words(string)
    word_array.each do |word|
      if special?(word)
        braille_word = plaintext_special_to_braille_char(word)
      elsif number?(word)
        braille_word = plaintext_number_to_braille_number(word)
      else
        braille_word = plaintext_word_to_braille_word(word)
      end

      braille_word = concat_braille_hashes(braille_word,space)
      braille_text = concat_braille_hashes(braille_text,braille_word)
    end
    braille_text
  end

  #6 finally we print them out into a string

  def braille_text_to_braille_printable(braille_text)
    braille_string = ""
    until braille_text[:top].length == 0 #I would love nothing more than for the following line to be on three lines.  but it doesn't run.
      braille_string = braille_string + braille_text[:top][0..79].reduce(:+) + "\n" + braille_text[:mid][0..79].reduce(:+) + "\n" + braille_text[:bot][0..79].reduce(:+) + "\n"

      braille_text[:top] = braille_text[:top][80..-1].to_a
      braille_text[:mid] = braille_text[:mid][80..-1].to_a
      braille_text[:bot] = braille_text[:bot][80..-1].to_a
    end
    braille_string
  end

  #7 Do it all in one method

  def encode_braille_to_text(string)
    braille_text = plaintext_text_to_braille_text(string)
    braille_string = braille_text_to_braille_printable(braille_text)
    braille_string
  end


end

# filereader = FileReader.new(ARGV[0],ARGV[1])
# filereader.convert_text_to_braille
