class Student_list

  require 'csv'

  def initialize
    @list = []
  end

  def get_list
    @list
  end

  def add(student)
    @list << student
  end

  def remove(student)
    @list.pop(student)
  end

  def save(filename)
    CSV.open(filename, "wb") do |file|
      @list.each { |student| file << student.info.to_a.flatten }
    end
  end

  def load(filename, mode= "w")
    case mode
    when "w"
      @list.clear
    when "a"
    else
      raise "Invalid value #{mode} for parameter mode of instance method load"
    end
    CSV.foreach(filename) { |line|
      studentinfo = Hash[*line]
      # Convert keys to symbols
      studentinfo = studentinfo.inject({}){|memo,(k,v)|
         memo[k.to_sym] = v
         memo
      }
      @list << Student.new(studentinfo)
      p Student.new(studentinfo)
    }
  end

  def show(depth= 0)
    @list.each do |student|
      info = student.info.select{|k, v| k != :name}.to_a[0, depth]
      info.map! {|entry| entry.join(": ")}
      puts "* #{student.info[:name]} - #{info.join(", ")}"
    end
  end

  def count
    @list.count
  end

end
