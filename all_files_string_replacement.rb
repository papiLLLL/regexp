# This class replaces string in files in directory.
# And make file into replacement directory with date on current directory.
# If change regexp, please modify @XXXX_regexpX in initialize method.
# How to use command is following.
#
#   ruby file_string_replacement.rb [directory]
#
class AllFilesStringReplacement
  def initialize(directory, _none = nil)
    @now = Time.now.strftime('%Y%m%d%H%M%S')
    @directory = directory
    @new_directory = "replacement_#{@now}"
    @before_regexp1 = /^\s+(AUTHORITY|BUILTIN|DESKTOP)/
    @after_regexp1 = "\t" # When replace, add $1
    @before_regexp2 = '1 個のファイルが正常に処理されました。0 個のファイルを処理できませんでした'
    @after_regexp2 = "\r\n"
    @before_regexp3 = /\n/
    @after_regexp3 = ''
  end

  def start_replacement
    files = fetch_all_files_in_directory
    raise Errno::ENOENT if files.empty?
    make_directory
    read_and_write_files(files)
  rescue Errno::ENOENT => e
    puts "class=[#{e.class}] message=[#{e.message}]"
  rescue IOError => e
    puts "class=[#{e.class}] message=[#{e.message}]"
  end

  def fetch_all_files_in_directory
    Dir.entries(@directory)[2..-1]
  end

  def make_directory
    Dir.mkdir(@new_directory)
  end

  def read_and_write_files(files)
    files.each do |file|
      File.open("#{@directory}/#{file}", 'rt:sjis:utf-8') do |content|
        result = replace_regexp(content.read)
        write_file(file, result)
      end
    end
  end

  def replace_regexp(content)
    content.gsub(@before_regexp1) { @after_regexp1 + Regexp.last_match(1) }
      .gsub(@before_regexp2) { @after_regexp2 }
      .gsub(@before_regexp3) { @after_regexp3 }
  end

  def write_file(file, result)
    File.open("#{@new_directory}/#{file}", 'wt:sjis:utf-8') do |content|
      content.write(result)
    end
  end
end

begin
  fsr = AllFilesStringReplacement.new(*ARGV)
  fsr.start_replacement
rescue ArgumentError => e
  puts "class=[#{e.class}] message=[#{e.message}]"
end
