require_relative '../lib/night_writer_2'
require_relative '../lib/night_reader_2'
require 'pry'

class FileReaderWriter

  attr_reader :input

  def initialize (input,output)
    @text_input = File.open(input,'r')
    @output = File.open(output, 'w')
    @braille_input = File.read(input)
    binding.pry
  end

  def convert_text_to_braille
    night = NightWriter2.new
    braille = ""
    @text_input.each_line do |l|
      braille = night.encode_braille_to_text(l).to_s
      @output.write(braille)
    end
    chars = braille.chars.length/6
  end

  def convert_braille_to_text
    night = NightReader2.new
    binding.pry
    text = night.decode_braille_to_text(@braille_input).to_s
    binding.pry
    @output.write(text)
    chars = text.chars.length
  end

end
