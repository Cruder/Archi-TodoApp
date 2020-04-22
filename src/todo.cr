require "option_parser"
require "./task_repository"
require "./task_span_formatter"

repo = TaskRepository.new

OptionParser.parse do |parser|
  parser.banner = "Usage: todo [arguments]"
  parser.on("-l", "--list", "List active todos") do
    tasks = repo.active
    tasks.each do |task|
      puts task.to_string(TaskSpanFormatter.new)
    end
  end
  parser.on("-a NAME", "--add=NAME", "Add a new todo") do |name|
    task = Task.new(name)
    repo.insert(task)
  end
  parser.on("-d ID", "--done=ID", "Mark a todo as done") do |id|
    repo.complete(id)
  end
  parser.on("-r ID", "--remove=ID", "Remove a todo") do |id|
    repo.remove(id)
  end
  parser.on("-h", "--help", "Show this help") do
    puts parser
    exit
  end
  parser.invalid_option do |flag|
    STDERR.puts "ERROR: #{flag} is not a valid option."
    STDERR.puts parser
    exit(1)
  end
end
