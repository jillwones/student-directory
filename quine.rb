# $0 is the name of the file used to start the program
# so it's basically just the name of the file
# for this file $0 is quine.rb

# This file simply prints its own source code

File.open($0, 'r') do |file|
  file.readlines.each do |line|
    puts line 
  end
end 