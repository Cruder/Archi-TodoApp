require "../activity"

class ListTasksActivity < Activity
  @bad_input = false
  @repo = TaskRepository.new

  def on_render(io : IO)
    io << "\n\nBad input\n\n".colorize(:red) if @bad_input
    tasks = @repo.active
    tasks.each do |task|
      io << task.to_string(TaskSpanFormatter.new) + "\n"
    end
    io << "\nPress [ENTER] to continue\n\n"
  end

  def on_input(input : String)
    stack_pop
  end
end
