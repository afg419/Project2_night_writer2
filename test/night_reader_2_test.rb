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


  def test_braille_printable_to_braille_text
    night = NightReader2.new
    braille_text = " . . 0 0 . . 0 . 0 . . . \n . . 0 0 . . 0 . 0 . . . \n . . 0 0 . . 0 . 0 . . . \n . . 0 0 . . 0 . 0 . . . \n . . 0 0 . . 0 . 0 . . . \n . . 0 0 . . 0 . 0 . . . \n ".gsub(" ","")
    expected = {  top: %w{. . 0 0 . . 0 . 0 . . . . . 0 0 . . 0 . 0 . . . },
                  mid: %w{. . 0 0 . . 0 . 0 . . . . . 0 0 . . 0 . 0 . . . },
                  bot: %w{. . 0 0 . . 0 . 0 . . . . . 0 0 . . 0 . 0 . . . }}
    computed = night.braille_printable_to_braille_text(braille_text)
    assert_equal expected, computed
  end

  def test_braille_text_to_braille_chars
    night = NightReader2.new
    braille_hash = {top: %w{ . . 0 . 0 . 0 . },
                    mid: %w{ . . 0 0 . 0 0 . },
                    bot: %w{ . 0 . . . . 0 . } }
    expected = [ {top: %w{. .}, mid: %w{. .}, bot: %w{. 0} } , {top: %w{0 .}, mid: %w{0 0}, bot: %w{. .} }, {top: %w{0 .}, mid: %w{. 0}, bot: %w{. .} } , {top: %w{0 .}, mid: %w{0 .}, bot: %w{0 .} }   ]
    computed = night.braille_text_to_braille_chars(braille_hash)
    assert_equal expected, computed
  end

  def test_braille_chars_to_braille_words
    night = NightReader2.new
    array = [ {top: %w{. .}, mid: %w{. .}, bot: %w{. 0} } , {top: %w{0 .}, mid: %w{0 0}, bot: %w{. .} }, {top: %w{. .}, mid: %w{. .}, bot: %w{. .} }, {top: %w{0 .}, mid: %w{. 0}, bot: %w{. .} } , {top: %w{0 .}, mid: %w{0 .}, bot: %w{0 .} }   ]
    expected = [ [{top: %w{. .}, mid: %w{. .}, bot: %w{. 0} } , {top: %w{0 .}, mid: %w{0 0}, bot: %w{. .} } ], [{top: %w{. .}, mid: %w{. .}, bot: %w{. .} } ], [{top: %w{0 .}, mid: %w{. 0}, bot: %w{. .} } , {top: %w{0 .}, mid: %w{0 .}, bot: %w{0 .} } ]  ]
    computed = night.braille_chars_to_braille_words(array)
    assert_equal expected, computed
  end

  def test_special_braille_word_identification
    night = NightReader2.new
    yes = [{top: %w{ 0 0 }, mid: %w{ 0 0 }, bot: %w{ 0 0 } }]
    no = [{top: %w{ 0 . }, mid: %w{ 0 0 }, bot: %w{ 0 0 } }]
    assert_equal true, night.special?(yes)
    assert_equal false, night.special?(no)
  end

  def test_braille_number_identification
    night = NightReader2.new
    yes =[{top: %w{ 0 . }, mid: %w{ 0 .}, bot: %w{ . 0 } },{top: %w{ 0 . }, mid: %w{ . . }, bot: %w{ . .  } } ]
    no = [{top: %w{ 0 . }, mid: %w{ 0 0 }, bot: %w{ 0 0 } }]
    assert_equal true, night.number?(yes)
    assert_equal false, night.number?(no)
  end

  def test_braille_digit_to_plaintext_digit
    night = NightReader2.new
    zero = {top: %w{ 0 . }, mid: %w{ . . }, bot: %w{ . .  } }
    six = {top: %w{ 0 0 }, mid: %w{ 0 0 }, bot: %w{ . .  } }
    assert_equal "0", night.braille_digit_to_plaintext_digit(zero)
    assert_equal "6", night.braille_digit_to_plaintext_digit(six)

  end

  def test_braille_special_to_plaintext_word
    night = NightReader2.new
    cat = [{top: %w{ 0 0 }, mid: %w{ 0 0 }, bot: %w{ 0 0 } }]
    but = [{top: %w{ . . }, mid: %w{ 0 . }, bot: %w{ . . } }]
    assert_equal "cat", night.braille_special_to_plaintext_word(cat)
    assert_equal "but", night.braille_special_to_plaintext_word(but)
  end

  def test_braille_char_to_plaintext_char
    night = NightReader2.new
    a = {top: %w{ 0 . }, mid: %w{ . . }, bot: %w{ . . } }
    expected = "a"
    computed = night.braille_char_to_plaintext_char(a)
    assert_equal expected, computed
  end

  def test_braille_word_to_plaintext_word
    night = NightReader2.new
    word = [ {top: %w{. .}, mid: %w{. .}, bot: %w{. 0} } , {top: %w{0 .}, mid: %w{0 0}, bot: %w{. .} }, {top: %w{0 .}, mid: %w{. 0}, bot: %w{. .} } , {top: %w{0 .}, mid: %w{0 .}, bot: %w{0 .} } , {top: %w{0 .}, mid: %w{0 .}, bot: %w{0 .} } ,  {top: %w{0 .}, mid: %w{. 0}, bot: %w{0 .} }   ]
    expected = "Hello"
    computed = night.braille_word_to_plaintext_word(word)
    assert_equal expected, computed
  end

  def test_braille_num_to_plaintext_num
    night = NightReader2.new
    num = [{top: %w{ 0 . }, mid: %w{ 0 .}, bot: %w{ . 0 } },{top: %w{ 0 . }, mid: %w{ . . }, bot: %w{ . .  } },{top: %w{ 0 0 }, mid: %w{ 0 0 }, bot: %w{ . .  } },{top: %w{ 0 0 }, mid: %w{ 0 0 }, bot: %w{ . .  } }]
    expected = "066"
    computed = night.braille_number_to_plaintext_number(num)
    assert_equal expected, computed
  end

  def test_braille_printable_to_plaintext_text_no_caps_no_specials_no_nums
    night = NightReader2.new
    day = NightWriter2.new
    expected = "hey baby how are you "
    compute1 = day.encode_braille_to_text(expected)
    computed = night.braille_printable_to_plaintext_text(compute1)
    assert_equal expected, computed
  end


  def test_braille_printable_to_plaintext_text_with_caps_and_specials_and_punctuation
    night = NightReader2.new
    day = NightWriter2.new
    expected = "Hello! what is your name? I like you and I don't even care even care. "
    compute1 = day.encode_braille_to_text(expected)
    computed = night.braille_printable_to_plaintext_text(compute1)
    assert_equal expected, computed
  end

  def test_braille_printable_to_plaintext_text_with_caps_and_specials_and_numbers
    night = NightReader2.new
    day = NightWriter2.new
    expected = "Hello Jon but 12 when 134 is now "
    compute1 = day.encode_braille_to_text(expected)
    computed = night.braille_printable_to_plaintext_text(compute1)
    assert_equal expected, computed
  end

  def test_plaintext_text_to_printable
    night = NightReader2.new
    text = "012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789"
    expected = "01234567890123456789012345678901234567890123456789012345678901234567890123456789\n0123456789\n"
    computed = night.plaintext_text_to_printable(text)
    assert_equal expected, computed
  end

  def test_decode_braille_to_text_less_than_80
    night = NightReader2.new
    day = NightWriter2.new
    expected = "Turing is so great I can't even feel my hands! Where is the sun? Am I a mole? \n"
    computed1 = day.encode_braille_to_text(expected)
    computed = night.decode_braille_to_text(computed1)
    assert_equal expected, computed
  end

  def test_decode_braille_to_text_more_than_80
    night = NightReader2.new
    day = NightWriter2.new
    text = "Turing is so great I can't even feel my hands! Where is the sun? Am I a mole? Who are my friends?"
    expected = "Turing is so great I can't even feel my hands! Where is the sun? Am I a mole? Wh\no are my friends? \n"
    computed1 = day.encode_braille_to_text(text)
    computed = night.decode_braille_to_text(computed1)
    assert_equal expected, computed
  end

end
