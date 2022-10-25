
# ------------------------------- STUDENT DIRECTORY ---------------------------------

# ---------------------------- INTERACTIVE MENU SECTION -----------------------------

require 'io/console'

@students = []

def print_menu
  puts "1. Input the students"
  puts "2. Show the students"
  puts "3. Save the list to students.csv"
  puts "4. Load the list from students.csv"
  puts "9. Exit"
end 

def interactive_menu
  loop do
     print_menu
     process(STDIN.gets.chomp) 
  end 
end

def process selection 
  case selection 
    when "1" then input_students
    when "2" then show_students 
    when "3" then save_students
    when "4" then load_students
    when "9" then exit
    else 
      puts "Invalid selection"
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

def save_students
  # open the folder for writing
  file = File.open("students.csv", "w")
  # iterate over the array of students
  @students.each do |student|
    student_data = [student[:name], student[:cohort], student[:height], student[:hobbies]]
    csv_line = student_data.join(',')
    file.puts csv_line
  end 
  file.close 
end 

def load_students(filename = "students.csv")
  file = File.open(filename, "r")
  file.readlines.each do |line|
    data_array = line.chomp.split(',') # splits the csv lines into an array
    name = data_array[0] # data at index 0 will always be the name
    cohort = data_array[1] # data at index 1 will always be an inputted cohort or default value of 'November'
    height = data_array[2] # data at index 2 will always be either an inputted height or 0.0
    hobbies = data_array[3..-1] # data from index 3 to last index will be the hobbies, the hobbies variable will always be an array, even if there is only 1 hobby or 'None' inputted
    add_student_data_to_students_array(name, cohort, height, hobbies)
  end 
  file.close 
end 

# try_load_students allows us to load data from students.csv by passing it as an
# argument when running this file

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

def print_students_if_first_letter_W  
  @students.each_with_index { |student,i| puts "#{i + 1}. #{student[:name]} (#{student[:cohort]} cohort) (Height: #{student[:height]}m) (Hobbies: #{student[:hobbies].join(', ')})".center(IO.console.winsize[1]) if student[:name].start_with? 'W' }
end 

def print_students_if_name_length_less_than_12  
  @students.each_with_index { |student,i| puts "#{i + 1}. #{student[:name]} (#{student[:cohort]} cohort) (Height: #{student[:height]}m) (Hobbies: #{student[:hobbies].join(', ')})".center(IO.console.winsize[1]) if student[:name].length < 12 }
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

