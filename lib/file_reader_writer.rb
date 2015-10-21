require_relative '../lib/night_writer_2'
require_relative '../lib/night_reader_2'
require 'pry'

class FileReaderWriter

  attr_reader :input

  def initialize (input,output)
    @text_input = File.open(input,'r')
    @output = File.open(output, 'w')
    @braille_input = File.read(input)
  end

  def convert_text_to_braille
    night = NightWriter2.new
    @text_input.each_line do |l|
      braille = night.plaintext_string_to_braille_string(l)
      @output.write(braille)
    end
  end

  def convert_braille_to_text
    night = NightReader2.new
    binding.pry
    text = night.decode_braille_to_text(@braille_input)
    binding.pry
    @output.write(text)
  end

end
