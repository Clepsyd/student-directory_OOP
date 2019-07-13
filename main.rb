require 'csv'
require './lib/menu'
require './lib/student'
require './lib/student_list'

# Initialize list of students
@students = Student_list.new

# Fetch data fields for students from fields.csv, convert them to symbols.
@students_data_fields = CSV.read('./lib/fields.csv').flatten
@students_data_fields.map! { |field| field.to_sym }

def add
  student = Student.new
  @students_data_fields.each { |field|
    puts "Please enter the student's #{field}"
    student.add_info(field, STDIN.gets.strip)
    system("clear") || system("cls")
  }
  @students.add(student)
  puts "#{student.info[:name]} added to the directory"
end

def remove
  puts "Which student would you like removed from the list?"
  name = gets.strip
  student = @students.get_list.select {|student| student.info[:name] == name}.first
  if !student
    puts "Sorry, we could not find this name in our records"
  else
    @students.remove(student) 
    puts "#{student.info[:name]} deleted from repository"
  end
end

def show
  puts "How many fields would you like to see for each student?"
  puts "Leave field empty to only show the names."
  depth = gets.strip.to_i
  if @students.get_list.empty?
    empty_list_message
  else
    @students.show(depth)
  end
end

def empty_list_message
  puts "There isn't any student in this directory at the moment."
  puts "In the main menu:"
  puts " - 1 to add a student"
  puts " - 5 to load an existing list"
end

def save
  puts "Where would you like the file to be saved? (extension .csv not required)"
  filename = gets.strip
  if filename.empty? or filename.match?(/[^0-9A-Za-z\-_]/)
    puts "The file name is empty or contains forbidden characters, saving failed."
  else
    @students.save("#{filename}.csv")
    puts "#{@students.count} students saved to #{filename}.csv"
  end
end

def load
  puts "Type the name of the file you would like to load. (extension .csv not required)"
  filename = "#{gets.strip}.csv"
  if File.exist?(filename)
    load_file_exists(filename)
  else
    puts "This file does not exist, loading failed."
  end
end

def load_file_exists(filename)
  puts "Would you like to add to the current list (a), or overwrite it (w)?"
  mode = gets.strip
  if mode != "w" && mode != "a"
    puts "Sorry only 'a' or 'w' are valid answers. Aborting loading."
  else 
    @students.load(filename, mode)
    puts "#{filename} loaded #{@students.count} students into the current list"
  end
end

# Initialize the menu
menu = Menu.new

# Modify this list to change the menu
menu_entries = [
  [1, "Add student", method(:add)],
  [2, "Remove student", method(:remove)],
  [3, "Show students", method(:show)],
  [4, "Save students", method(:save)],
  [5, "Load students", method(:load)],
  [9, "Exit", method(:exit)]
]

menu_entries.each {|entry|
  menu.add(Menu_entry.new(*entry))
}

loop do
  puts "Press enter to go to the menu..."
  gets
  system("clear") || system("cls")
  menu.show
  input = gets.strip.to_i
  system("clear") || system("cls")
  menu.launch(input)
end
