require "colorize"
require "./task_repository"
require "./task_span_formatter.cr"
require "./activity"

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
