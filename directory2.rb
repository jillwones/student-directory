# let's put all of the students into an array
# students = [
#   {name: "Dr Hannibal Lecter", cohort: :november},
#   {name: "Darth Vader", cohort: :november},
#   {name: "Nurse Ratched", cohort: :november},
#   {name: "Michael Corleone", cohort: :november},
#   {name: "Alex DeLarge", cohort: :november},
#   {name: "The Wicked Witch of the West", cohort: :november},
#   {name: "Terminator", cohort: :november},
#   {name: "Freddy Krueger", cohort: :november},
#   {name: "The Joker", cohort: :november},
#   {name: "Joffrey Baratheon", cohort: :november},
#   {name: "Norman Bates", cohort: :november}
# ]


def print_header
  puts "The student of Villains Academy"
  puts "------------"
end

def print_students names 
  names.each { |student| puts "#{student[:name]} (#{student[:cohort]} cohort)"}
end 

def print_footer names
  puts "Overall, we have #{names.count} great students"
end 

def input_students
  puts "Please enter the name of the student you wish to enter into the database"
  puts "If you do not wish to enter another student, please hit return twice"
  name = gets.chomp
  puts "Please enter the cohort they are in (Enter the month they enroll)"
  cohort = gets.chomp.to_sym

  students = []

  while !name.empty? do
    students << {name: name, cohort: cohort}
    puts "Now we have #{students.count} #{students.count == 1 ? 'student': 'students'}"
    puts "Enter the next students name, or stop"
    name = gets.chomp 
    break if name == 'stop'
    puts "Please enter the cohort they are in"
    cohort = gets.chomp
  end
  students 
end

# nothing happens until we call the methods
students = input_students
print_header
print_students students
print_footer students