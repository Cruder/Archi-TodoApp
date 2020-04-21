
abstract class IInput
    abstract def read
end

abstract class IOutput
    abstract def send(message : String)
    abstract def help
end

class ConsoleOutput < IOutput
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

class ConsoleInput < IInput
    def read
        gets
    end
end

input = ConsoleInput.new
output = ConsoleOutput.new

output.send("Enter something")
smth = input.read



output.send("Your typed: #{smth}")
