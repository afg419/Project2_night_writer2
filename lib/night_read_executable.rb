require_relative 'night_reader_2'
require_relative 'file_reader_writer'

filereader2 = FileReaderWriter.new(ARGV[0],ARGV[1])

puts "Created '#{ARGV[1]}' containing #{filereader2.convert_braille_to_text} characters"
