class Student
  
  attr_reader :info

  def initialize(hash)
    @info = hash ? hash : Hash.new()
  end

  def add_info(key, value)
    @info[key] = value == "" ? "N/A" : value
  end

  def remove_info(key)
    @info.delete(key)
  end

end