abstract class IOutput
  abstract def send(message : String)
  abstract def help
end

class Console::Output < IOutput
  def send(message)
    puts message
  end

  def help
    puts "You can do :"
    puts "new <content todo> : "
    puts "rem <id-todo>"
    puts "list"
    puts "complete <id-todo>"
  end
end

class Console::Input
  @@catch = -> { gets }

  def self.set(new_catch : Proc(String?))
    @@catch = new_catch
  end

  def self.read : String?
    @@catch.try(&.call) || gets
  end
end

output = Console::Output.new

output.send("Enter something")
smth = Console::Input.read



output.send("Your typed: #{smth}")
