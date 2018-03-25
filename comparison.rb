# This class compare files in each directories.
# And make file
class Comparison
  def initialize(before_directory, after_directory, _none = nil)
    @directory = [before_directory, after_directory]
  end

  def start
    confirm_directory
  end

  def confirm_directory
    files = []
    @directory.each do |dir|
      files.push(Dir.glob("*", base: dir).sort)
    end
  end
end

comparison = Comparison.new(*ARGV)
comparison.start