require_relative 'dictionary_tools'
require 'pry'


class NightReader2
  include DictionaryTools

  def braille_input_to_braille_hash(string)
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

  def braille_hash_to_braille_char_hashes(braille_hash)
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

  def wrap_braille_chars_into_words(braille_char_array)
    space = {top: %w{. .}, mid: %w{. .}, bot: %w{. .}}
    wrapped = braille_char_array.slice_when{|x,y| x == space || y == space}.to_a
    # All space entries of the original array are returned as singleton arrays, and all other characters returned in arrays.
    wrapped
  end

  #4 Now that we are all processed, we can begin to translate to plaintext.  First we identify special characters/words

  def special?(braille_word)
    default = false
    SPECIALS.invert.keys.each do |special|
      if braille_num_to_hash(special) == braille_word[0]
        default = true
      end
    end
    default
  end

  #5 If a braille word is special, we return the corresponding plaintext word

  def braille_special_to_plaintext(braille_word)
    key = 0
    SPECIALS.invert.keys.each do |special|
      if braille_num_to_hash(special) == braille_word[0]
        key = special
        break
      end
    end

    SPECIALS.invert[key].to_s

  end

end
