require 'minitest'
require 'pry'
require 'dictionary_tools'

class TestDicionaryTools < Minitest::Test

  include DictionaryTools

  def test_testing_syntax
  end

  def test_dictionary_tools_exists
    assert DictionaryTools
  end


  def test_indices_to_braille
    yes = %w{ 1 2 3 }
    no = %w{ 2 }
    assert_equal '0', indices_to_braille(yes,'2')
    assert_equal '.', indices_to_braille(no,'1')
  end

  def test_braille_num_to_hash
    input = %w{ 1 4 5 }
    expected = { top: ['0' ,'0' ],
                 mid: ['.' ,'0' ],
                 bot: ['.' ,'.' ]}
    computed = braille_num_to_hash(input)
    assert_equal expected, computed
  end

  def test_braille_hash_to_num
    input = { top: ['0' ,'0' ],
                 mid: ['.' ,'0' ],
                 bot: ['.' ,'.' ]}
    expected = %w{ 1 4 5 }
    computed = braille_hash_to_num(input)
    assert_equal expected, computed
  end

  def test_concat_braille_hashes
    input1 = {top: ['0' ,'0' ],
              mid: ['.' ,'0' ],
              bot: ['.' ,'.' ]}
    input2 = {top: ['0' ,'0' ],
              mid: ['.' ,'0' ],
              bot: ['.' ,'.' ]}
    expected = {top: ['0' ,'0' , '0', '0' ],
                mid: ['.' ,'0' , '.' ,'0' ],
                bot: ['.' ,'.' , '.' , '.']}
    computed = concat_braille_hashes(input1,input2)
    assert_equal expected, computed
  end

end
