require './lib/menu'
require './lib/student'
require './lib/student_list'

# Initialize list of students
@students = Student_list.new

# Add elements to this list if more informations are required
@students_data_fields = [
  :name,
  :cohort,
  :age,
  :city,
  :hobbies
]

def add
  student = Student.new
  @students_data_fields.each { |field|
    puts "Please enter the student's #{field}"
    student.add_info(field, STDIN.gets.strip)
  }
  @students.add(student)
end

def remove
  puts "Which student would you like removed from the list?"
  student = @students.get_list.select {|student| student.name}.first
  if student.empty?
    puts "Sorry, we could not find this name in our records"
  else
    @students.delete(student) 
  end
end

def show
  puts "How many fields would you like to see for each student?"
  puts "Leave field empty to only show the names."
  depth = gets.strip.to_i
  @students.show(depth)
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
    puts "Would you like to add to the current list (a), or overwrite it (w)?"
    mode = gets.strip
    if mode != "w" && mode != "a"
      puts "Sorry only 'a' or 'w' are valid answers. Aborting loading."
    else 
      @students.load(filename, mode)
      puts "#{filename} loaded #{@students.count} students into the current list"
    end
  else
    puts "This file does not exist, loading failed."
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
  menu.show
  menu.launch(gets.strip.to_i)
end
