require "colorize"
require "./task_repository"

class Controller
  @factories = Hash(String, Proc(Controller, Activity)).new
  @stack = Array(Activity).new
  @open = true

  def initialize(@io : IO = STDOUT)
  end

  def handle_input(input : String)
    @stack.last.on_input(input)
  end

  def handle_update
    close! if empty?
  end

  def handle_render
    @stack.last?.try { |activity| activity.on_render(@io) }
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

  def close!
    @open = false
  end

  def open?
    @open
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
    io << "r - Remove Task\n"
    io << "d - Mark task as done\n"
    io << "q - Quit\n"
  end

  def on_input(input : String)
    @bad_input = false

    case input
    when "q", "quit" then stack_pop
    when "l" then stack_push("list_tasks")
    when "r" then stack_push("remove_tasks")
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

controller = Controller.new
controller.register("main") { |ctrl| MainActivity.new(ctrl) }
#controller.register("list_tasks") { |ctrl| TaskListActivity.new(ctrl) }
controller.register("remove_tasks") { |ctrl| RemoveTaskActivity.new(ctrl) }
controller.register("done_tasks") { |ctrl| DoneTaskActivity.new(ctrl) }

controller.push("main")

while controller.open?
  controller.handle_render

  input = (gets || "").chomp
  controller.handle_input(input)

  controller.handle_update
end
