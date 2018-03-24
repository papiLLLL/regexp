# This class replaces string in file.
# And make file with date on current directory.
# How to use command is following.
#
#   ruby file_string_replacement.rb [before string] [after string]
class FileStringReplacement
  def initialize(file, before_regexp, after_regexp)
    @file = file
    @before_regexp = Regexp.new(before_regexp)
    @after_regexp = after_regexp
    @now = Time.now.strftime('%Y%m%d%H%M%S')
  end

  def start_replacement
    result = read_all_the_contents_in_file
    write_file(result)
  rescue SystemCallError => e
    puts "class=[#{e.class}] message=[#{e.message}]"
  rescue IOError => e
    puts "class=[#{e.class}] message=[#{e.message}]"
  end

  def read_all_the_contents_in_file
    File.open(@file, 'rt:sjis:utf-8') do |file|
      replace_regexp(file.read)
    end
  end

  def replace_regexp(file)
    file.gsub(@before_regexp, @after_regexp)
  end

  def write_file(result)
    new_file = @file.dup.insert(@file.rindex('.'), "_#{@now}")
    File.open(new_file, 'w') do |file|
      file.write(result)
    end
  end
end

begin
  fsr = FileStringReplacement.new(*ARGV)
  fsr.start_replacement
rescue ArgumentError => e
  puts "class=[#{e.class}] message=[#{e.message}]"
end
