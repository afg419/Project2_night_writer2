require 'minitest'
require 'pry'
require 'night_writer_2'
require 'night_reader_2'
require 'dictionary_tools'

class TestNightWriter2 < Minitest::Test

  include DictionaryTools

  def test_testing_syntax
  end

  def test_night_writer_exists
    assert NightWriter2
  end

  def test_plaintext_to_words
    night = NightWriter2.new
    string = "Hello how are you"
    assert_equal %w{Hello how are you}, night.plaintext_to_words(string)
  end


  def test_special_word_identification
    night = NightWriter2.new
    string1 = "cat"
    string2 = "dog"
    assert_equal true, night.special?(string1)
    assert_equal false, night.special?(string2)
  end

  def test_plaintext_special_to_braille_char1
    night = NightWriter2.new
    special = "cat"
    expected = { top:['0','0'] , mid:['0' ,'0'], bot:['0','0'] }
    computed = night.plaintext_special_to_braille_char(special)
    assert_equal expected , computed
  end

  def test_plaintext_special_to_braille_char2
    night = NightWriter2.new
    special = "but"
    expected = { top:['.','.'] , mid:['0' ,'.'], bot:['.','.'] }
    computed = night.plaintext_special_to_braille_char(special)
    assert_equal expected , computed
  end

  def test_capital_letter_identification
    night = NightWriter2.new
    a = 'a'
    b = 'B'
    assert_equal false, night.capital?(a)
    assert_equal true, night.capital?(b)
  end

  def test_plaintext_char_to_braille_char1
    night = NightWriter2.new
    a = 'a'
    x = 'x'
    f = 'f'
    expected_a = { top:['0','.'] , mid:['.' ,'.'], bot:['.','.'] }
    expected_x = { top:['0','0'] , mid:['.' ,'.'], bot:['0','0'] }
    expected_f = { top:['0','0'] , mid:['0' ,'.'], bot:['.','.'] }
    assert_equal  expected_a , night.plaintext_char_to_braille_char(a)
    assert_equal  expected_x , night.plaintext_char_to_braille_char(x)
    assert_equal  expected_f , night.plaintext_char_to_braille_char(f)
  end

  def test_plaintext_char_to_braille_char2_with_caps
    night = NightWriter2.new
    a = 'A'
    x = 'X'
    f = 'F'
    expected_a = { top:['.','.','0','.'] , mid:['.','.','.' ,'.'], bot:['.','0','.','.'] }
    expected_x = { top:['.','.','0','0'] , mid:['.','.','.' ,'.'], bot:['.','0','0','0'] }
    expected_f = { top:['.','.','0','0'] , mid:['.','.','0' ,'.'], bot:['.','0','.','.'] }
    assert_equal  expected_a , night.plaintext_char_to_braille_char(a)
    assert_equal  expected_x , night.plaintext_char_to_braille_char(x)
    assert_equal  expected_f , night.plaintext_char_to_braille_char(f)
  end

  def test_plaintext_word_to_braille_hash
    night = NightWriter2.new
    word = "Hello"
    expected = {top: %w{ . . 0 . 0 . 0 . 0 . 0 .  },
                mid: %w{ . . 0 0 . 0 0 . 0 . . 0  },
                bot: %w{ . 0 . . . . 0 . 0 . 0 .  }}
    computed = night.plaintext_word_to_braille_word(word)
    assert_equal expected , computed
  end

  def test_number_true
    night = NightWriter2.new
    word = "12"
    assert_equal true, night.number?(word)
  end


  def test_number_false
    night = NightWriter2.new
    word = "aa"
    assert_equal false, night.number?(word)
  end

  def test_plaintext_number_to_braille_number
    night = NightWriter2.new
    word = "3225"
    expected = {top: %w{ 0 . 0 0 0 0 0 0 0 0},
                mid: %w{ 0 . . 0 . . . . 0 .},
                bot: %w{ . 0 . . . . . . . .}}
    computed = night.plaintext_number_to_braille_number(word)
    assert_equal expected, computed
  end

  def test_plaintext_string_to_braille_hash
    night = NightWriter2.new
    text = "Hello Aa but a cat"
    expected = {top: %w{ . . 0 . 0 . 0 . 0 . 0 . . . . . 0 . 0 . . . . . . . 0 . . . 0 0 . .},
                mid: %w{ . . 0 0 . 0 0 . 0 . . 0 . . . . . . . . . . 0 . . . . . . . 0 0 . .},
                bot: %w{ . 0 . . . . 0 . 0 . 0 . . . . 0 . . . . . . . . . . . . . . 0 0 . .} }
    computed = night.plaintext_text_to_braille_text(text)
    assert_equal expected, computed
  end

  def test_braille_hash_to_braille_string
    night = NightWriter2.new
    text = "Hello Aa but a cat"
    braille_hash = {top: %w{ . . 0 . 0 . 0 . 0 . 0 . . . . . 0 . 0 . . . . . . . 0 . . . 0 0 . .},
                    mid: %w{ . . 0 0 . 0 0 . 0 . . 0 . . . . . . . . . . 0 . . . . . . . 0 0 . .},
                    bot: %w{ . 0 . . . . 0 . 0 . 0 . . . . 0 . . . . . . . . . . . . . . 0 0 . .} }
    expected = %w{ . . 0 . 0 . 0 . 0 . 0 . . . . . 0 . 0 . . . . . . . 0 . . . 0 0 . .}.reduce(:+) + "\n" + %w{ . . 0 0 . 0 0 . 0 . . 0 . . . . . . . . . . 0 . . . . . . . 0 0 . .}.reduce(:+) + "\n" + %w{ . 0 . . . . 0 . 0 . 0 . . . . 0 . . . . . . . . . . . . . . 0 0 . .}.reduce(:+) + "\n"
    computed = night.braille_text_to_braille_printable(braille_hash)
    assert_equal expected, computed
  end

  def test_encode_braille_to_text
    night = NightWriter2.new
    text = "Hello Aa but a cat"
    expected = %w{ . . 0 . 0 . 0 . 0 . 0 . . . . . 0 . 0 . . . . . . . 0 . . . 0 0 . .}.reduce(:+) + "\n" + %w{ . . 0 0 . 0 0 . 0 . . 0 . . . . . . . . . . 0 . . . . . . . 0 0 . .}.reduce(:+) + "\n" + %w{ . 0 . . . . 0 . 0 . 0 . . . . 0 . . . . . . . . . . . . . . 0 0 . .}.reduce(:+) + "\n"
    computed = night.encode_braille_to_text(text)
    assert_equal expected, computed
  end

  def test_plaintext_numbers_to_braille_string
    night = NightWriter2.new
    text = "100"
    expected = "0.0.0.0...\n0.0.......\n.0........\n"
    computed = night.encode_braille_to_text(text)
    assert_equal expected, computed
  end

  def test_plaintext_string_with_numbers_to_braille_string
    night = NightWriter2.new
    text = "Hello Aa but a cat 12"
    expected = "..0.0.0.0.0.....0.0.......0...00..0.0.00..\n..00.00.0..0..........0.......00..0.0.....\n.0....0.0.0....0..............00...0......\n"
    computed = night.encode_braille_to_text(text)
    assert_equal expected, computed
  end
#########################################


end




# day = NightWriter2.new
# braille = day.encode_braille_to_text("Hello but when is now")
# night = NightReader2.new
# puts "plaintext= " + night.braille_string_to_plaintext_string(braille).inspect
