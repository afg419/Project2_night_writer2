require_relative 'night_writer_2'
require_relative 'night_reader_2'

class FileReader

  def initialize (input,output)
    @input = File.open(input,'r')
    @output = File.open(output, 'w')
  end

  def convert_text_to_braille
    night = NightWriter2.new
    @input.each_line do |l|
      braille = night.plaintext_string_to_braille_string(l)
      @output.write(braille)
    end
  end

  def convert_braille_to_text
    night = NightReader2.new
    @input.each_line do |l|
      text = night.decode_braille_to_text(l)
      @output.write(text)
    end
  end

end
