require "../activity"

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
