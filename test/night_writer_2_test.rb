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

  def test_plaintext_pre_process
    night = NightWriter2.new
    string = "Hello how are you"
    assert_equal %w{Hello how are you}, night.plaintext_input_pre_process(string)
  end


  def test_special_word_identification
    night = NightWriter2.new
    string1 = "cat"
    string2 = "dog"
    assert_equal true, night.special?(string1)
    assert_equal false, night.special?(string2)
  end

  def test_plaintext_special_to_braille_hash1
    night = NightWriter2.new
    special = "cat"
    expected = { top:['0','0'] , mid:['0' ,'0'], bot:['0','0'] }
    computed = night.plaintext_special_to_braille_hash(special)
    assert_equal expected , computed
  end

  def test_plaintext_special_to_braille_hash2
    night = NightWriter2.new
    special = "but"
    expected = { top:['.','.'] , mid:['0' ,'.'], bot:['.','.'] }
    computed = night.plaintext_special_to_braille_hash(special)
    assert_equal expected , computed
  end

  def test_capital_letter_identification
    night = NightWriter2.new
    a = 'a'
    b = 'B'
    assert_equal false, night.capital?(a)
    assert_equal true, night.capital?(b)
  end

  def test_plaintext_char_to_braille_hash1
    night = NightWriter2.new
    a = 'a'
    x = 'x'
    f = 'f'
    expected_a = { top:['0','.'] , mid:['.' ,'.'], bot:['.','.'] }
    expected_x = { top:['0','0'] , mid:['.' ,'.'], bot:['0','0'] }
    expected_f = { top:['0','0'] , mid:['0' ,'.'], bot:['.','.'] }
    assert_equal  expected_a , night.plaintext_char_to_braille_hash(a)
    assert_equal  expected_x , night.plaintext_char_to_braille_hash(x)
    assert_equal  expected_f , night.plaintext_char_to_braille_hash(f)
  end

  def test_plaintext_char_to_braille_hash2_with_caps
    night = NightWriter2.new
    a = 'A'
    x = 'X'
    f = 'F'
    expected_a = { top:['.','.','0','.'] , mid:['.','.','.' ,'.'], bot:['.','0','.','.'] }
    expected_x = { top:['.','.','0','0'] , mid:['.','.','.' ,'.'], bot:['.','0','0','0'] }
    expected_f = { top:['.','.','0','0'] , mid:['.','.','0' ,'.'], bot:['.','0','.','.'] }
    assert_equal  expected_a , night.plaintext_char_to_braille_hash(a)
    assert_equal  expected_x , night.plaintext_char_to_braille_hash(x)
    assert_equal  expected_f , night.plaintext_char_to_braille_hash(f)
  end

  def test_plaintext_word_to_braille_hash
    night = NightWriter2.new
    word = "Hello"
    expected = {top: %w{ . . 0 . 0 . 0 . 0 . 0 .  },
                mid: %w{ . . 0 0 . 0 0 . 0 . . 0  },
                bot: %w{ . 0 . . . . 0 . 0 . 0 .  }}
    computed = night.plaintext_word_to_braille_hash(word)
    assert_equal expected , computed
  end

  def test_plaintext_string_to_braille_hash
    night = NightWriter2.new
    text = "Hello Aa but a cat"
    expected = {top: %w{ . . 0 . 0 . 0 . 0 . 0 . . . . . 0 . 0 . . . . . . . 0 . . . 0 0 . .},
                mid: %w{ . . 0 0 . 0 0 . 0 . . 0 . . . . . . . . . . 0 . . . . . . . 0 0 . .},
                bot: %w{ . 0 . . . . 0 . 0 . 0 . . . . 0 . . . . . . . . . . . . . . 0 0 . .} }
    computed = night.plaintext_string_to_braille_hash(text)
    assert_equal expected, computed
  end

  def test_braille_hash_to_braille_string
    night = NightWriter2.new
    text = "Hello Aa but a cat"
    braille_hash = {top: %w{ . . 0 . 0 . 0 . 0 . 0 . . . . . 0 . 0 . . . . . . . 0 . . . 0 0 . .},
                    mid: %w{ . . 0 0 . 0 0 . 0 . . 0 . . . . . . . . . . 0 . . . . . . . 0 0 . .},
                    bot: %w{ . 0 . . . . 0 . 0 . 0 . . . . 0 . . . . . . . . . . . . . . 0 0 . .} }
    expected = %w{ . . 0 . 0 . 0 . 0 . 0 . . . . . 0 . 0 . . . . . . . 0 . . . 0 0 . .}.reduce(:+) + "\n" + %w{ . . 0 0 . 0 0 . 0 . . 0 . . . . . . . . . . 0 . . . . . . . 0 0 . .}.reduce(:+) + "\n" + %w{ . 0 . . . . 0 . 0 . 0 . . . . 0 . . . . . . . . . . . . . . 0 0 . .}.reduce(:+) + "\n"
    computed = night.braille_hash_to_braille_string(braille_hash)
    assert_equal expected, computed
  end

  def test_plaintext_input_to_braille_string
    night = NightWriter2.new
    text = "Hello Aa but a cat"
    expected = %w{ . . 0 . 0 . 0 . 0 . 0 . . . . . 0 . 0 . . . . . . . 0 . . . 0 0 . .}.reduce(:+) + "\n" + %w{ . . 0 0 . 0 0 . 0 . . 0 . . . . . . . . . . 0 . . . . . . . 0 0 . .}.reduce(:+) + "\n" + %w{ . 0 . . . . 0 . 0 . 0 . . . . 0 . . . . . . . . . . . . . . 0 0 . .}.reduce(:+) + "\n"
    computed = night.plaintext_input_to_braille_string(text)
    assert_equal expected, computed
  end
##########################################

  def test_braille_input_to_braille_hash
    night = NightReader2.new
    braille_text = " . . 0 0 . . 0 . 0 . . . \n . . 0 0 . . 0 . 0 . . . \n . . 0 0 . . 0 . 0 . . . \n . . 0 0 . . 0 . 0 . . . \n . . 0 0 . . 0 . 0 . . . \n . . 0 0 . . 0 . 0 . . . \n ".gsub(" ","")
    expected = {  top: %w{. . 0 0 . . 0 . 0 . . . . . 0 0 . . 0 . 0 . . . },
                  mid: %w{. . 0 0 . . 0 . 0 . . . . . 0 0 . . 0 . 0 . . . },
                  bot: %w{. . 0 0 . . 0 . 0 . . . . . 0 0 . . 0 . 0 . . . }}
    computed = night.braille_input_to_braille_hash(braille_text)
    assert_equal expected, computed
  end

  def test_braille_hash_to_braille_char_hashes
    night = NightReader2.new
    braille_hash = {top: %w{ . . 0 . 0 . 0 . },
                    mid: %w{ . . 0 0 . 0 0 . },
                    bot: %w{ . 0 . . . . 0 . } }
    expected = [ {top: %w{. .}, mid: %w{. .}, bot: %w{. 0} } , {top: %w{0 .}, mid: %w{0 0}, bot: %w{. .} }, {top: %w{0 .}, mid: %w{. 0}, bot: %w{. .} } , {top: %w{0 .}, mid: %w{0 .}, bot: %w{0 .} }   ]
    computed = night.braille_hash_to_braille_char_hashes(braille_hash)
    assert_equal expected, computed
  end

  def test_wrap_braille_chars_into_words
    night = NightReader2.new
    array = [ {top: %w{. .}, mid: %w{. .}, bot: %w{. 0} } , {top: %w{0 .}, mid: %w{0 0}, bot: %w{. .} }, {top: %w{. .}, mid: %w{. .}, bot: %w{. .} }, {top: %w{0 .}, mid: %w{. 0}, bot: %w{. .} } , {top: %w{0 .}, mid: %w{0 .}, bot: %w{0 .} }   ]
    expected = [ [{top: %w{. .}, mid: %w{. .}, bot: %w{. 0} } , {top: %w{0 .}, mid: %w{0 0}, bot: %w{. .} } ], [{top: %w{. .}, mid: %w{. .}, bot: %w{. .} } ], [{top: %w{0 .}, mid: %w{. 0}, bot: %w{. .} } , {top: %w{0 .}, mid: %w{0 .}, bot: %w{0 .} } ]  ]
    computed = night.wrap_braille_chars_into_words(array)
    assert_equal expected, computed
  end

  def test_special_braille_word_identification
    night = NightReader2.new
    yes = [{top: %w{ 0 0 }, mid: %w{ 0 0 }, bot: %w{ 0 0 } }]
    no = [{top: %w{ 0 . }, mid: %w{ 0 0 }, bot: %w{ 0 0 } }]
    assert_equal true, night.special?(yes)
    assert_equal false, night.special?(no)
  end

  def test_braille_special_to_plaintext
    night = NightReader2.new
    cat = [{top: %w{ 0 0 }, mid: %w{ 0 0 }, bot: %w{ 0 0 } }]
    but = [{top: %w{ . . }, mid: %w{ 0 . }, bot: %w{ . . } }]
    assert_equal "cat", night.braille_special_to_plaintext(cat)
    assert_equal "but", night.braille_special_to_plaintext(but)
  end

  def test_braille_hash_to_plaintext_char
    night = NightReader2.new
    a = {top: %w{ 0 . }, mid: %w{ . . }, bot: %w{ . . } }
    expected = "a"
    computed = night.braille_hash_to_plaintext_char(a)
    assert_equal expected, computed
  end





















  # def test_input_to_char_array
  #   skip
  #   night = NightWriter.new
  #   text
  #   night.input()
  # end
  #
  # def test_translate_one_lower_case_plaintext_to_braille
  #   skip
  #   night = NightWriter.new
  #   alphabet = %w{ a b c d e f g h i j k l m n o p q r s t u v w x y z }
  #   assert_equal {top:['0','.'] , mid:['.','.'] , bot:['.','.']}, night.plaintext_to_braille(alphabet[0])
  # end
  #
  # def test_braille_num_to_braille_hash_1
  #   night = NightWriter.new
  #   expected = { top:['0','.'] , mid:['.' ,'0'], bot:['0','.'] }
  #   received = night.braille_num_to_hash( ['1','3','5'] )
  #   assert_equal expected, received
  # end
  #
  # def test_braille_num_to_braille_hash_2
  #   night = NightWriter.new
  #   expected = { top:['.','.'] , mid:['0' ,'.'], bot:['.','.'] }
  #   received = night.braille_num_to_hash( ['2'] )
  #   assert_equal expected, received
  # end
  #
  # def test_plaintext_char_to_braille_hash_1
  #   night = NightWriter.new
  #   plaintext = 'a'
  #   expected = { top:['0','.'] , mid:['.' ,'.'], bot:['.','.'] }
  #   received = night.plaintext_char_to_braille_hash(plaintext)
  #   assert_equal expected, received
  # end
  #
  # def test_plaintext_char_to_braille_hash_2
  #   night = NightWriter.new
  #   plaintext = 'x'
  #   expected = { top:['0','0'] , mid:['.' ,'.'], bot:['0','0'] }
  #   received = night.plaintext_char_to_braille_hash(plaintext)
  #   assert_equal expected, received
  # end
  #
  # def test_plaintext_char_to_braille_hash_space
  #   night = NightWriter.new
  #   plaintext = ' '
  #   expected = { top:['.','.'] , mid:['.' ,'.'], bot:['.','.'] }
  #   received = night.plaintext_char_to_braille_hash(plaintext)
  #   assert_equal expected, received
  # end
  #
  # def test_plaintext_char_to_braille_with_capital
  #   night = NightWriter.new
  #   plaintext = 'A'
  #   expected = { top: %w{ . . 0 . } , mid: %w{ . . . . }, bot: %w{ . 0 . .} }
  #   received = night.plaintext_char_to_braille_hash(plaintext)
  #   assert_equal expected, received
  # end
  #
  # def test_concat_braille_hashes_1
  #   night = NightWriter.new
  #   a = night.plaintext_char_to_braille_hash('a')
  #   b = night.plaintext_char_to_braille_hash('b')
  #   expected = {top: ['0','.','0','.'], mid: ['.','.','0','.'], bot: ['.','.','.','.']}
  #   received = night.concat_braille_hashes(a,b)
  #   assert_equal expected, received
  # end
  #
  # def test_concat_braille_hashes_2
  #   night = NightWriter.new
  #   a = night.plaintext_char_to_braille_hash('x')
  #   b = night.plaintext_char_to_braille_hash('y')
  #   expected = {top: ['0','0','0','0'], mid: ['.','.','.','0'], bot: ['0','0','0','0']}
  #   received = night.concat_braille_hashes(a,b)
  #   assert_equal expected, received
  # end
  #
  # def test_concat_braille_hashes_with_space
  #   night = NightWriter.new
  #   a = night.plaintext_char_to_braille_hash('x')
  #   b = night.plaintext_char_to_braille_hash(' ')
  #   expected = {top: ['0','0','.','.'], mid: ['.','.','.','.'], bot: ['0','0','.','.']}
  #   received = night.concat_braille_hashes(a,b)
  #   assert_equal expected, received
  # end
  #
  # def test_concat_braille_hashes_with_two_spaces
  #   night = NightWriter.new
  #   a = night.plaintext_char_to_braille_hash(' ')
  #   b = night.plaintext_char_to_braille_hash(' ')
  #   expected = {top: ['.','.','.','.'], mid: ['.','.','.','.'], bot: ['.','.','.','.']}
  #   received = night.concat_braille_hashes(a,b)
  #   assert_equal expected, received
  # end
  #
  # def test_capitalize_true
  #   night = NightWriter.new
  #   a = 'A'
  #   assert_equal true, night.capital?(a)
  # end
  #
  # def test_capitalize_false
  #   night = NightWriter.new
  #   b = 'b'
  #   assert_equal false, night.capital?(b)
  # end
  #
  # def test_braille_line_builder
  #   night = NightWriter.new
  #   plaintext = "Hello "
  #   expected = {top: %w{ . . 0 . 0 . 0 . 0 . 0 . . . },
  #               mid: %w{ . . 0 0 . 0 0 . 0 . . 0 . . },
  #               bot: %w{ . 0 . . . . 0 . 0 . 0 . . . }}
  #   received = night.build_braille_text(plaintext)
  #   assert_equal expected , received
  # end

end
