# let's put all of the students into an array
students = [
  ["Dr Hannibal Lecter", :november],
  ["Darth Vader", :november],
  ["Nurse Ratched", :november],
  ["Michael Corleone", :november],
  ["Alex DeLarge", :november],
  ["The Wicked Witch of the West", :november],
  ["Terminator", :november],
  ["Freddy Krueger", :november],
  ["The Joker", :november],
  ["Joffrey Baratheon", :november],
  ["Norman Bates", :november]
]
def print_header
  puts "The student of Villains Academy"
  puts "------------"
end

def print_students names 
  names.each { |name| puts "#{name[0]} (#{name[1]} cohort)"}
end 

def print_footer names
  puts "Overall, we have #{names.count} great students"
end 

# nothing happens until we call the methods
print_header
print_students students
print_footer students