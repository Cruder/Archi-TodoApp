require "../activity"

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
