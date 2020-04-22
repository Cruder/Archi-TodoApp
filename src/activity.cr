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
