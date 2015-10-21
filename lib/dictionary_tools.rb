
require 'pry'
module DictionaryTools


  ############################################################

DICTIONARY = {
    a: %w{ 1 },
    b: %w{ 1 2 },
    c: %w{ 1 4 },
    d: %w{ 1 4 5 },
    e: %w{ 1 5 },
    f: %w{ 1 2 4 },
    g: %w{ 1 2 4 5 },
    h: %w{ 1 2 5 },
    i: %w{ 2 4 },
    j: %w{ 2 4 5 },
    k: %w{ 1 3 },
    l: %w{ 1 2 3 },
    m: %w{ 1 3 4 },
    n: %w{ 1 3 4 5 },
    o: %w{ 1 3 5 },
    p: %w{ 1 2 3 4 },
    q: %w{ 1 2 3 4 5 },
    r: %w{ 1 2 3 5 },
    s: %w{ 2 3 4 },
    t: %w{ 2 3 4 5 },
    u: %w{ 1 3 6 },
    v: %w{ 1 2 3 6 },
    w: %w{ 2 4 5 6 },
    x: %w{ 1 3 4 6 },
    y: %w{ 1 3 4 5 6 },
    z: %w{ 1 3 5 6 },
    _: %w{ 6 },
    " ": %w{ },
  }

  SPECIALS = {
    but: %w{ 2 },
    cat: %w{ 1 2 3 4 5 6 }
  }

  NUMBERS = {
    '#'=> %w{ 1 2 6},
    '0'=> %w{ 1 },
    '1'=> %w{ 1 2 },
    '2'=> %w{ 1 4 },
    '3'=> %w{ 1 4 5 },
    '4'=> %w{ 1 5 },
    '5'=> %w{ 1 2 4 },
    '6'=> %w{ 1 2 4 5 },
    '7'=> %w{ 1 2 5 },
    '8'=> %w{ 2 4 },
    '9'=> %w{ 2 4 5 },
  }

  def indices_to_braille(num_array,num)
    num_array.include?(num) ? '0' : '.'
  end

  def braille_num_to_hash(num_array)
    {top: [indices_to_braille(num_array,'1'), indices_to_braille(num_array,'4') ],
     mid: [indices_to_braille(num_array,'2'), indices_to_braille(num_array,'5') ],
     bot: [indices_to_braille(num_array,'3'), indices_to_braille(num_array,'6') ]}
  end

  def braille_hash_to_num(braille_hash)
    x = []
    output = []
    braille_hash.values.each do |val|
      x = x + val
    end

    x = x.map do |entry|
      ((entry == "0") ? 1 : 0)
      #binding.pry
    end

    output = ["1"*x[0], "2"*x[2], "3"*x[4], "4"*x[1], "5"*x[3], "6"*x[5]].reject{|x| x == ""}

  end

  ##########################WorkingwithBraille###########################

  def concat_braille_hashes(hash1,hash2,hash3 = {top: [], mid:[], bot:[]})
    hash = {}
    hash2.each do |key,val|
      hash[key] = hash1[key] + hash2[key] + hash3[key]
    end
    hash
  end


end


include DictionaryTools

puts braille_hash_to_num({ top:['0','.'] , mid:['.' ,'.'], bot:['.','.'] }).inspect
