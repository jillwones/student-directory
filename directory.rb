
# ------------------------------- STUDENT DIRECTORY ---------------------------------

# ---------------------------- INTERACTIVE MENU SECTION -----------------------------

require 'io/console'

@students = []

class String
  def red; "\e[31m#{self}\e[0m"; end
  def green; "\e[32m#{self}\e[0m"; end
  def yellow; "\e[33m#{self}\e[0m"; end
  def cyan; "\e[36m#{self}\e[0m"; end
  def magenta; "\e[35m#{self}\e[0m"; end
end


def print_menu
  puts "1. Input the students".green
  puts "2. Show the students".yellow
  puts "3. Save the list to students.csv".cyan
  puts "4. Load the list from students.csv".magenta
  puts "5. Search students".yellow
  puts "9. Exit".red
end 

def interactive_menu
  loop do
     print_menu
     process(STDIN.gets.chomp) 
  end 
end

def process selection 
  case selection 
    when "1" then input_students; puts "Data added!".center(IO.console.winsize[1])
    when "2" then show_students 
    when "3" 
      loop do 
        puts "What file would you like to save the data in? students.csv is recommended"
        filename = STDIN.gets.chomp
        if File.exist?(filename)
          save_students(filename); puts "Data saved!".center(IO.console.winsize[1])
          break 
        else 
          puts "File doesn't exist"
        end
      end
    when "4" 
      loop do 
        puts "What file do you wish to load student data from? students.csv is recommended"
        filename = STDIN.gets.chomp 
        if File.exist?(filename)
          load_students(filename); puts "Data loaded!".center(IO.console.winsize[1])
          break 
        else 
          puts "File doesn't exist"
        end 
      end
    when "5" then search_students_menu
    when "9" then exit
    else 
      puts "Invalid selection"
  end 
end

def search_students_menu 
  loop do 
    search_students
    search_students_output(STDIN.gets.chomp)
  end 
end 

def search_students
  puts "Filter by:".green
  puts "1. First letter".yellow
  puts "2. Maximum name length".cyan
  puts "3. Back to Main Menu".magenta
end

def search_students_output(choice)
  case choice 
  when "1" then search_by_first_letter
  when "2" then search_by_name_length
  when "3" then interactive_menu
  else 
    puts "Invalid input"
  end 
end 


# -------------------------- SHOW STUDENTS SECTION ------------------------------

def print_header
  puts "The students of Villains Academy".center(IO.console.winsize[1])
  puts "------------".center(IO.console.winsize[1])
end

def print_students_list
  @students.each_with_index { |student,i| puts "#{i + 1}. #{student[:name]} (#{student[:cohort]} cohort) (Height: #{student[:height] != 0.0 ? "#{student[:height]}m" : "No height data"}) (Hobbies: #{student[:hobbies].join(', ')})".center(IO.console.winsize[1]) }
end 

def print_footer 
  if !@students.empty?
    puts "Overall, we have #{@students.count} great #{@students.count == 1 ? 'student': 'students'}".center(IO.console.winsize[1])
  else 
    puts "There are currently no students at Villains Academy".center(IO.console.winsize[1])
  end
end 

def show_students
  print_header
  print_students_list
  print_footer 
end

# ----------------------------- INPUTTING STUDENT DATA -------------------------------

def add_student_data_to_students_array name, cohort, height, hobbies
  @students << {name: name, cohort: cohort.to_sym, height: height.to_f, hobbies: hobbies}
end

def add_name 
  puts "Please enter the name of the student you wish to enter into the database"
  puts "If you do not wish to enter another student, please hit return twice"
  name = STDIN.gets.chomp
end

def add_cohort
  months_array = ["January","February","March","April","May","June","July","August","September","October","November","December",'']
  puts "Please enter the students cohort (Example: November or December)"
  while cohort = STDIN.gets.chomp
    if !months_array.include? cohort 
      puts "That is not a valid month"
    else
      cohort = 'November' if cohort.empty?
      break
    end
  end
  cohort
end

def add_height 
  puts "Please enter the students height in metres"
  height = STDIN.gets.chomp
end 

def add_hobbies 
  hobbies = []
  puts "What are the students hobbies?"
  puts "Please enter 'None' if the student has no hobbies"
  puts "Press enter twice if you wish to stop adding hobbies"
  hobby = STDIN.gets.chomp
  while !hobby.empty? 
    hobbies << hobby 
    hobby = STDIN.gets.chomp 
  end 
  hobbies 
end 

def input_students
  loop do 
    name = add_name
    break if name.empty?
    cohort = add_cohort
    height = add_height 
    hobbies = add_hobbies
    add_student_data_to_students_array(name, cohort, height, hobbies)
    puts "Now we have #{@students.count} #{@students.count == 1 ? 'student': 'students'}"
  end
end 

# -------------------- CODE RELATING TO SAVING AND LOADING DATA ---------------------

def save_students(filename = "students.csv")
  # open the folder for writing
  file = File.open(filename, "w")
  # iterate over the array of students
  @students.each do |student|
    student_data = [student[:name], student[:cohort], student[:height], student[:hobbies]]
    csv_line = student_data.join(',')
    file.puts csv_line
  end 
  file.close 
end 

def load_students(filename = "students.csv")
  File.open(filename, "r").readlines.each do |line|
    data_array = line.chomp.split(',') # splits the csv lines into an array
    name = data_array[0] # data at index 0 will always be the name
    cohort = data_array[1] # data at index 1 will always be an inputted cohort or default value of 'November'
    height = data_array[2] # data at index 2 will always be either an inputted height or 0.0
    hobbies = data_array[3..-1] # data from index 3 to last index will be the hobbies, the hobbies variable will always be an array, even if there is only 1 hobby or 'None' inputted
    add_student_data_to_students_array(name, cohort, height, hobbies)
  end 
end

# try_load_students allows us to load data from students.csv by passing it as an
# argument when running this file, if no argument is given then no previous data is
# loaded

def try_load_students
  filename = ARGV.first # first argument from the command line
  return if filename.nil? # get out of the method if it isn't given
  if File.exist?(filename) # if it exists
    load_students(filename)
    puts "Loaded #{@students.count} students from #{filename}"
  else 
    puts "Sorry, #{filename} doesn't exist."
    exit 
  end 
end 

# --------------------- METHODS MADE ANSWERING STEP 8 QUESTIONS ---------------------

def search_by_first_letter  
  puts "What letter do you want to search for?"
  letter = STDIN.gets.chomp
  @students.each_with_index do |student,i| 
    puts "#{i + 1}. #{student[:name]} (#{student[:cohort]} cohort) (Height: #{student[:height]}m) (Hobbies: #{student[:hobbies].join(', ')})".center(IO.console.winsize[1]) if student[:name].start_with? letter 
  end
end 

def search_by_name_length  
  puts "What is the maximum length of the name you wish to search for?"
  length = STDIN.gets.chomp.to_i
  @students.each_with_index { |student,i| puts "#{i + 1}. #{student[:name]} (#{student[:cohort]} cohort) (Height: #{student[:height]}m) (Hobbies: #{student[:hobbies].join(', ')})".center(IO.console.winsize[1]) if student[:name].length < length }
end

def print_students_by_cohorts  
  sorted_hash = {}
  @students.each do |student|
    cohort = student[:cohort]
    sorted_hash[cohort] = [] if sorted_hash[cohort].nil?
    sorted_hash[cohort] << student[:name] 
  end 
  puts sorted_hash.to_s.center(IO.console.winsize[1]) if !sorted_hash.empty?
end

# ----------- END OF CODE - BELOW WE CALL THE METHODS TO RUN THE PROGRAM -------------

try_load_students
interactive_menu

# ----------------------------- QUESTIONS AND ANSWERS -----------------------------

# STEP 8 QUESTIONS:

# Question 1:

# We're using the each() method to iterate over an array of students. 
# How can you modify the program to print a number before the name of each 
# student, e.g. "1. Dr. Hannibal Lecter"? Hint: look into each_with_index()

# def print_students names 
#   names.each_with_index { |student,i| puts "#{i + 1}. #{student[:name]} (#{student[:cohort]} cohort)" }
# end

# Question 2:

# Modify your program to only print the students whose name begins with 
# a specific letter.

# Method added above

# Question 3:

# Modify your program to only print the students whose name is shorter than 
# 12 characters.

# Method added above

# Question 4: 

# Rewrite the each() method that prints all students using while or until 
# control flow methods (Loops).

# def print_students names 
#   i = 0
#   while i < names.length
#     puts "#{names[i][:name]} (#{names[i][:cohort]} cohort)"
#     i += 1
#   end
# end

# Question 5:

# Our code only works with the student name and cohort. Add more information: 
# hobbies, country of birth, height, etc.

# Changed the students_input method to now ask for height and hobbies too, the 
# hobbies calls on the add_hobbies method and that returns an array of hobbies 
# inputted, the height and hobbies list is appended to the students array in the same
# way as the name or cohort, to have the hobbies array printed nicely in 
# the print_students method, I joined the hobbies array together so it looks nicer:
# Hobbies: #{student[:hobbies].join(', ')

# Question 6:

# Research how the method center() of the String class works. 
# Use it in your code to make the output beautifully aligned.

# I found that to get the size of the current terminal window you must require 
# 'io/console', after that IO.console.winsize generates an array with the height 
# and width of the terminal window, IO.console.winsize[1] returns just the width 
# of the open window - so center(IO.console.winsize[1]) applied to the strings 
# outputted in the print methods will center each string to the current width of the
# window, if you change the width and rerun the program the output will still be 
# centered.

#Question 7:

# In the input_students method the cohort value is hard-coded. 
# How can you ask for both the name and the cohort? What if one of the values is empty? 
# Can you supply a default value? The input will be given to you as a string? 
# How will you convert it to a symbol? What if the user makes a typo?

# I changed my input_students method so it also asks for their cohort, if the cohort 
# value is empty then the default value is 'November', to convert to symbol is just 
# .to_sym. When the user makes a typo it gets the user to type it in again until a 
# capitalized month is typed in, I did this by having a months array and checking 
# if the months array includes what the user typed in.

# Question 8:

# Once you complete the previous exercise, change the way the users are displayed: 
# print them grouped by cohorts. To do this, you'll need to get a list of all existing 
# cohorts (the map() method may be useful but it's not the only option), iterate over
# it and only print the students from that cohort.

# Method added above

# Question 9:

# Right now if we have only one student, the user will see a message 
# "Now we have 1 students", whereas it should be "Now we have 1 student". 
# How can you fix it so that it uses the singular form when appropriate and plural 
# form otherwise?

# I added the ternary operator, #{students.count == 1 ? 'student': 'students'}, to
# to replace the word students

# Question 10:

# We've been using the chomp() method to get rid of the last return character. 
# Find another method among those provided by the String class that could be used 
# for the same purpose (although it will require passing some arguments).

# chop() method could also be used 

# Question 11:

# Find and correct all the typos in a different file.

# Question 12:

# What happens if the user doesn't enter any students? It will try to print an 
# empty list. How can you use an if statement (Control Flow) to only print the 
# list if there is at least one student in there?

# Added an if statement to the print_footer method

# STEP 14 QUESTIONS:

# Question 1:

# After we added the code to load the students from file, we ended up with adding 
# the students to @students in two places. The lines in load_students() and 
# input_students() are almost the same. This violates the DRY (Don't Repeat Yourself) 
# principle. How can you extract them into a method to fix this problem?

# Made the add_student_data_to_students_array method and pass in the name, cohort
# height and hobbies are arguments

# Question 2:

# How could you make the program load students.csv by default if no file 
# is given on startup? Which methods would you need to change?

# Would change the try_load_students method to:

# def try_load_students
#   filename = 'students.csv' # hard code the students.csv filename
#   if File.exist?(filename) # if it exists, load it
#     load_students(filename)
#     puts "Loaded #{@students.count} students from #{filename}"
#   else 
#     puts "Sorry, #{filename} doesn't exist."
#     exit 
#   end 
# end 

# Question 3:

# Continue refactoring the code. Which method is a bit too long? 
# What method names are not clear enough? Anything else you'd change to make your 
# code look more elegant? Why?

# Input students method is over 20 lines long so lets break that into seperate methods

# Question 4:

# Right now, when the user choses an option from our menu, there's no way of 
# them knowing if the action was successful. Can you fix this and implement feedback
# messages for the user?

# In the process method I added "Data added!", "Data saved!" and "Data loaded!" 
# that will show in the terminal after students have been inputted, the inputted
# data has been saved and when saved data (csv file) is loaded

# Question 5:

# The filename we use to save and load data (menu items 3 and 4) is hardcoded. 
# Make the script more flexible by asking for the filename if the user chooses 
# these menu items.

# Added simple loop do end loops to the process method for the saving and loading 
# options, now the user is asked for a filename, students.csv is recommended, if the 
# user types in a file that does not exist they are told this and prompted again

# Question 6:

# We are opening and closing the files manually. Read the documentation of the 
# File class to find out how to use a code block (do...end) to access a file, so 
# that we didn't have to close it explicitly (it will be closed automatically when 
# the block finishes). Refactor the code to use a code block.

# altered the load_students method to behave this way

# Question 7:

# We are de-facto using CSV format to store data. However, Ruby includes a 
# library to work with the CSV files that we could use instead of working directly 
# with the files. Refactor the code to use this library.

# I would change the load method to start with the following:

# CSV.open(filename, "r").readlines.each do |line|

# and the save method to the following :

# CSV.open(filename, "w") do |csv|
#   @students.each do |student|
#     student_data = [student[:name], student[:cohort], student[:height], student[:hobbies]]
#     csv_line = student_data.join(',')
#     csv.puts csv_line
#   end 
# end

# add "require 'csv'" to this file to use the CSV library 

# Question 8:

# Write a short program that reads its own source code 
# (search Stack Overflow to find out how to get the name of the currently 
# executed file) and prints it on the screen.

# A file that prints its own source code and that is its only functionality
# is called a 'Quine', so the answer to this question can be found in
# quine.rb