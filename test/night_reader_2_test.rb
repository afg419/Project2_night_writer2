require 'minitest'
require 'pry'
require 'night_writer_2'
require 'night_reader_2'
require 'dictionary_tools'

class TestNightReader2 < Minitest::Test

  include DictionaryTools

  def test_testing_syntax
  end

  def test_night_reader_exists
    assert NightReader2
  end


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

  def test_braille_word_to_plaintext_word
    night = NightReader2.new
    word = [ {top: %w{. .}, mid: %w{. .}, bot: %w{. 0} } , {top: %w{0 .}, mid: %w{0 0}, bot: %w{. .} }, {top: %w{0 .}, mid: %w{. 0}, bot: %w{. .} } , {top: %w{0 .}, mid: %w{0 .}, bot: %w{0 .} } , {top: %w{0 .}, mid: %w{0 .}, bot: %w{0 .} } ,  {top: %w{0 .}, mid: %w{. 0}, bot: %w{0 .} }   ]
    expected = "Hello"
    computed = night.braille_word_to_plaintext_word(word)
    assert_equal expected, computed
  end

  def test_braille_string_to_plaintext_string
    night = NightReader2.new
    day = NightWriter2.new
    expected = "Hello Jon but when is now "
    compute1 = day.plaintext_string_to_braille_string(expected)
    computed = night.braille_string_to_plaintext_string(compute1)
    assert_equal expected, computed
  end


end
