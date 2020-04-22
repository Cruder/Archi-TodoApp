require "colorize"

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

  protected def stack_push(id : Symbol)
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
    io << ""
  end

  def on_input(input : String)
    @bad_input = false

    case input
    when "q", "quit" then stack_clear
    else
      @bad_input = true
    end
  end
end

controller = Controller.new
controller.register("main") { |ctrl| MainActivity.new(ctrl) }

controller.push("main")

while controller.open?
  controller.handle_render

  input = (gets || "").chomp
  controller.handle_input(input)

  controller.handle_update
end
