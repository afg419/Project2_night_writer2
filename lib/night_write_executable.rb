require_relative 'night_writer_2'
require_relative 'file_reader_writer'

filereader = FileReaderWriter.new(ARGV[0],ARGV[1])


puts "Created '#{ARGV[1]}' containing #{filereader.convert_text_to_braille} characters"
