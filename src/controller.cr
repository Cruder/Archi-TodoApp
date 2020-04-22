require "colorize"
require "./task_repository"
require "./task_span_formatter.cr"

class Controller
  @factories = Hash(String, Proc(Controller, Activity)).new
  @stack = Array(Activity).new
  @open = true

  def initialize(@io : IO = STDOUT)
  end

  def run(input_io = STDIN)
    handle_update

    while open?
      handle_render

      input = (input_io.gets || "").chomp
      handle_input(input)

      handle_update
    end
  end

  def push(id : String)
    activity = @factories[id].call(self)
    @stack << activity
  end

  def pop
    @stack.pop
  end

  def empty?
    @stack.empty?
  end

  def clear
    @stack.clear
  end

  def register(id : String, &block : Controller -> Activity)
    @factories[id] = block
  end

  def open?
    @open
  end

  private def close!
    @open = false
  end

  private def handle_input(input : String)
    @stack.last.on_input(input)
  end

  private def handle_update
    close! if empty?
  end

  private def handle_render
    @stack.last?.try { |activity| activity.on_render(@io) }
  end
end

abstract class Activity
  def initialize(@controller : Controller)
  end

  abstract def on_render(io : IO)
  abstract def on_input(input : String)

  protected def stack_push(id : String)
    @controller.push(id)
  end

  protected def stack_pop
    @controller.pop
  end

  protected def stack_clear
    @controller.clear
  end
end

class MainActivity < Activity
  @bad_input = false

  def on_render(io : IO)
    io << "\n\nBad input\n\n".colorize(:red) if @bad_input
    io << "Menu -\n"
    io << "l - List Tasks\n"
    io << "a - Add Task\n"
    io << "r - Remove Task\n"
    io << "d - Mark task as done\n"
    io << "q - Quit\n"
  end

  def on_input(input : String)
    @bad_input = false

    case input
    when "q", "quit" then stack_pop
    when "l" then stack_push("list_tasks")
    when "a" then stack_push("add_task")
    when "r" then stack_push("remove_task")
    when "d" then stack_push("done_tasks")
    else
      @bad_input = true
    end
  end
end

class RemoveTaskActivity < Activity
  @bad_input = false

  def on_render(io : IO)
    io << "\n\nBad input\n\n".colorize(:red) if @bad_input
    io << "\nTask ID > "
  end

  def on_input(input : String)
    @bad_input = false
    repo = TaskRepository.new
    begin
      repo.remove(input.to_i)
      stack_pop
    rescue ArgumentError
      @bad_input = true
    end
  end
end

class AddTaskActivity < Activity
  def on_render(io : IO)
    io << "\nName your task > "
  end

  def on_input(input : String)
    repo = TaskRepository.new
    task = Task.new(input)
    repo.insert(task)
    stack_pop
  end
end

class TaskListActivity < Activity
  @bad_input = false
  @repo = TaskRepository.new

  def on_render(io : IO)
    io << "\n\nBad input\n\n".colorize(:red) if @bad_input
    tasks = @repo.active
    tasks.each do |task|
      io << task.to_string(TaskSpanFormatter.new) + "\n"
    end
  end

  def on_input(input : String)
    @bad_input = false
    case input
    when "q", "quit" then stack_pop
    else
      @bad_input = true
    end
  end
end

class DoneTaskActivity < Activity
  @bad_input = false

  def on_render(io : IO)
    io << "\n\nBad input\n\n".colorize(:red) if @bad_input
    io << "\nTask ID > "
  end

  def on_input(input : String)
    @bad_input = false
    repo = TaskRepository.new
    begin
      repo.complete(input.to_i)
      stack_pop
    rescue ArgumentError
      @bad_input = true
    end
  end
end
