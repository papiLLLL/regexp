# -*- encoding: utf-8 -*-

class FileStringReplacement
  def initialize(file)
    @file = file
  end

  def read_all_the_contents_in_file
    begin
      File.open(@file[0], mode = 'rt:sjis:utf-8') do |file|
        file.read.split("\n").each do |str|
          puts str
        end
      end
    
    rescue SystemCallError => e
      puts %Q(class=[#{e.class}] message=[#{e.message}])
    rescue IOError => e
      puts %Q(class=[#{e.class}] message=[#{e.message}])
    end
  end
end

fsr = FileStringReplacement.new(ARGV)
fsr.read_all_the_contents_in_file
