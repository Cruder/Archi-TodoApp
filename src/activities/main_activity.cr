require "../activity"

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
    when "d" then stack_push("done_task")
    else
      @bad_input = true
    end
  end
end
