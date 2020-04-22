require "./controller"

controller = Controller.new
controller.register("main") { |ctrl| MainActivity.new(ctrl) }
# controller.register("list_tasks") { |ctrl| TaskListActivity.new(ctrl) }
controller.register("remove_tasks") { |ctrl| RemoveTaskActivity.new(ctrl) }
controller.register("done_tasks") { |ctrl| DoneTaskActivity.new(ctrl) }

controller.push("main")
controller.run
