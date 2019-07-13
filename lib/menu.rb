class Menu

  def initialize
    @menu = []
  end

  def add(entry)
    @menu << entry
  end

  def show
    @menu.sort_by { |entry| entry.number }.each do |entry|
      puts "#{entry.number}. #{entry.text}"
    end
  end

  def launch(number)
    # Looks for the entry matching the number and calls its action,
    # returns if no entry matching the number is found
    entry = @menu.select { |entry| entry.number == number}
    if entry.empty?
      return
    else
      entry.first.action.call
    end
  end

end

class Menu_entry

  attr_reader :number, :text, :action

  def initialize(number, text, action)
    @number = number
    @text = text
    @action = action
  end

end