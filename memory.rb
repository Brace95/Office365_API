=begin

Author: Brandon Stenhouse
Date: 04/02/20
Version: 0.1
Project: Office365 Automation
File: memory.rb
Purpose: This Ruby script is to handle storing data in files

=end

class Memory

  @file_path
  @content

  def initialize path="./memory.txt"
    @file_path = path
    if File.file?(@file_path) then
      existingFile()
    end
  end

  private

  def existingFile

  end

  def save

    File.open(@file_path, "w") do |f|
      f.write @content
    end

  end

end
