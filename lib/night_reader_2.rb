require_relative 'dictionary_tools'
require_relative 'file_reader_writer'
require_relative 'night_writer_2'
require_relative 'file_reader_writer'

require 'pry'


class NightReader2

  include DictionaryTools

  #1 We process the long string input into a hash three lines at a time

  def braille_printable_to_braille_text(string)
    braille_hash = {top: [], mid: [], bot:[]}
    braille_rows = string.split("\n")
    #we know that every third entry of above array appears in the same part of the line -- top mid or bot -- and so collect them in the hash.
    until braille_rows.length < 3 do
      braille_hash[:top] = braille_hash[:top] + braille_rows.shift.chars
      braille_hash[:mid] = braille_hash[:mid] + braille_rows.shift.chars
      braille_hash[:bot] = braille_hash[:bot] + braille_rows.shift.chars
    end

    braille_hash
    #outputs a top mid bot hash with array values whose entries are the characters of the string.
  end

  #2 Now we process the hash into an array of hashes, each representing only one character

  def braille_text_to_braille_chars(braille_hash)
    braille_char_array = []

    until braille_hash[:top].length < 2 do
      entry = {top: [] , mid:[] , bot:[]}
      entry[:top] = braille_hash[:top].shift(2)
      entry[:mid] = braille_hash[:mid].shift(2)
      entry[:bot] = braille_hash[:bot].shift(2)
      braille_char_array << entry
    end

    braille_char_array
  end

  #3 Now we take that array of hashes, and put characters in the same word together into arrays.

  def braille_chars_to_braille_words(braille_char_array)
    space = {top: %w{. .}, mid: %w{. .}, bot: %w{. .}}
    wrapped = braille_char_array.slice_when{|x,y| x == space || y == space}.to_a
    # All 'space' entries of the original array are returned as singleton arrays, and all other characters returned in arrays.
    wrapped
  end

  #4 Now that we are all pre-processed, we can begin to translate to plaintext.
  # First we identify special characters/words and numbers.

  def special?(braille_word)
    default = false
    SPECIALS.invert.keys.each do |special|
      if braille_num_to_hash(special) == braille_word[0] && braille_word.length == 1
        #All special 'words' correspond to single characters in braille.  This is why require length 1.
        default = true
      end
    end
    default
  end

  def number?(braille_word)
    braille_word[0] == braille_num_to_hash(NUMBERS['#'])
    #All numbers are preceded by a # braille character
  end



  #5 If a braille word is special, we return the corresponding plaintext word

  def braille_special_to_plaintext_word(braille_word)
    key = 0
    SPECIALS.invert.keys.each do |special|
      if braille_num_to_hash(special) == braille_word[0]
        key = special
        break
      end
    end
    SPECIALS.invert[key].to_s
  end

  #6 If a word is not special (numbers too), we process it a character at a time.


  def braille_char_to_plaintext_char(braille_hash)
    #### This method will return a shift and input letter in braille if it is capital
    braille_array = braille_hash_to_num(braille_hash)
    DICTIONARY.invert[braille_array].to_s
  end

  def braille_digit_to_plaintext_digit(braille_digit)
    braille_array = braille_hash_to_num(braille_digit)
    NUMBERS.invert[braille_array].to_s
  end

  #7 Now we use the methods of #6 on each character of the words we've prepared in #3

  def braille_word_to_plaintext_word(braille_word)
    word = ""
    capitalize = false #uses a capitalize bool to flag when the letter should be made capital

    braille_word.each do |braille_char|

      if braille_char == braille_num_to_hash(DICTIONARY[:_])
        capitalize = true #the next char in the loop will be made capital
      elsif capitalize == true
        char = braille_char_to_plaintext_char(braille_char).capitalize
        capitalize = false #the next char in the loop will not be capital (unless another shift key is present)
        word = word + char
      else
        char = braille_char_to_plaintext_char(braille_char)
        word = word + char
      end
    end
    word
  end

  def braille_number_to_plaintext_number(braille_word)
    word = ""
    braille_word.shift #deletes the '#' symbol
    braille_word.each do |braille_num|
      char = braille_digit_to_plaintext_digit(braille_num)
      word = word + char
    end
    word
  end

  #7 finally we are ready to F shit up.  We process the printable braille into a hash, separate that hash into words of
  # braille hash characters, identify which words are special or numbers, and convert them to text by the methods introduced
  # in #5 and #6.

  def braille_printable_to_plaintext_text(braille_string)

    plaintext = ""
    braille_hash = braille_printable_to_braille_text(braille_string)
    braille_char_array = braille_text_to_braille_chars(braille_hash)
    braille_words = braille_chars_to_braille_words(braille_char_array)

    #input has been pre processed into words of braille chars represented as hashes
    #Now we sort and convert them.

    braille_words.each do |braille_word|
      if special?(braille_word)
        word = braille_special_to_plaintext_word(braille_word)
      elsif number?(braille_word)
        word = braille_number_to_plaintext_number(braille_word)
      else
        word = braille_word_to_plaintext_word(braille_word)
      end
      plaintext = plaintext + word
    end
    plaintext
  end

  #8 double finally we are ready for printing.  The final method does it all
  # at once.

  def plaintext_text_to_printable(plaintext)
    printable = ""
    until plaintext == "" do
      printable = printable + plaintext[0..79] + "\n"
      plaintext = plaintext[80..-1].to_s
    end
    printable
  end

  def decode_braille_to_text(braille_string)
    text = braille_printable_to_plaintext_text(braille_string)
    plaintext_text_to_printable(text)
  end

end
