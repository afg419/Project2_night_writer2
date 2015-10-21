require_relative 'night_writer_2'
require_relative 'file_reader_writer'

filereader = FileReaderWriter.new(ARGV[0],ARGV[1])
filereader.convert_text_to_braille
