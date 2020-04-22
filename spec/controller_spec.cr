require "./spec_helper"

describe Controller do
  describe "#open?" do
    it "is open by default" do
      controller = Controller.new
      controller.open?.should be_truthy
    end

    it "is close when no activity run after update" do
      controller = Controller.new
      controller.run
      controller.open?.should be_falsey
    end
  end
end

describe MainActivity do
  context "when run" do
    it "quit when enter q" do
      output_catcher = IO::Memory.new
      controller = Controller.new(output_catcher)
      controller.register("main") { |ctrl| MainActivity.new(ctrl) }
      controller.push("main")

      fake_input = IO::Memory.new("q")
      controller.run(fake_input)

      controller.open?.should be_falsey
      output_catcher.to_s.should eq(
        <<-TXT
        Menu -
        l - List Tasks
        a - Add Task
        r - Remove Task
        d - Mark task as done
        q - Quit

        TXT
      )
    end

    it "display error when bad input" do
      output_catcher = IO::Memory.new
      controller = Controller.new(output_catcher)
      controller.register("main") { |ctrl| MainActivity.new(ctrl) }
      controller.push("main")

      fake_input = IO::Memory.new("foo\nq")
      controller.run(fake_input)

      controller.open?.should be_falsey
      output_catcher.to_s.should eq(
        <<-TXT
        Menu -
        l - List Tasks
        a - Add Task
        r - Remove Task
        d - Mark task as done
        q - Quit
        \e[31m

        Bad input

        \e[0mMenu -
        l - List Tasks
        a - Add Task
        r - Remove Task
        d - Mark task as done
        q - Quit

        TXT
      )
    end
  end
end

describe DoneTaskActivity do
  after_each { TaskRepository.flush }

  context "can mark task as done" do
    it "should mark task as done when entering task id" do
      repo = TaskRepository.new
      repo.insert(Task.new("test task"))
      task = repo.all.last

      output_catcher = IO::Memory.new
      controller = Controller.new(output_catcher)
      controller.register("main") { |ctrl| MainActivity.new(ctrl) }
      controller.register("done_task") { |ctrl| DoneTaskActivity.new(ctrl) }
      controller.push("main")

      fake_input = IO::Memory.new("d\n#{task.id}\nq")
      controller.run(fake_input)

      output_catcher.to_s.should eq(
        <<-TXT
        Menu -
        l - List Tasks
        a - Add Task
        r - Remove Task
        d - Mark task as done
        q - Quit
        
        Task ID > Menu -
        l - List Tasks
        a - Add Task
        r - Remove Task
        d - Mark task as done
        q - Quit

        TXT
      )

      task = repo.all.last
      task.done?.should eq(true)
    end
  end
end

describe RemoveTaskActivity do
  after_each { TaskRepository.flush }
  
  context "can remove task" do
    it "should remove task when entering task id" do
      repo = TaskRepository.new
      repo.insert(Task.new("test task"))
      task = repo.all.last
      
      output_catcher = IO::Memory.new
      controller = Controller.new(output_catcher)
      controller.register("main") { |ctrl| MainActivity.new(ctrl) }
      controller.register("remove_task") { |ctrl| RemoveTaskActivity.new(ctrl) }
      controller.push("main")

      fake_input = IO::Memory.new("r\n#{task.id}\nq")
      controller.run(fake_input)

      output_catcher.to_s.should eq(
        <<-TXT
        Menu -
        l - List Tasks
        a - Add Task
        r - Remove Task
        d - Mark task as done
        q - Quit
        
        Task ID > Menu -
        l - List Tasks
        a - Add Task
        r - Remove Task
        d - Mark task as done
        q - Quit

        TXT
      )

      repo.all.should eq([] of Task)
    end
  end
end

describe AddTaskActivity do
  after_each { TaskRepository.flush }
  
  context "can add task" do
    it "should add task when entering task name" do
      repo = TaskRepository.new
      output_catcher = IO::Memory.new
      controller = Controller.new(output_catcher)
      controller.register("main") { |ctrl| MainActivity.new(ctrl) }
      controller.register("add_task") { |ctrl| AddTaskActivity.new(ctrl) }
      controller.push("main")

      fake_input = IO::Memory.new("a\ntest\nq")
      controller.run(fake_input)

      output_catcher.to_s.should eq(
        <<-TXT
        Menu -
        l - List Tasks
        a - Add Task
        r - Remove Task
        d - Mark task as done
        q - Quit
        
        Name your task > Menu -
        l - List Tasks
        a - Add Task
        r - Remove Task
        d - Mark task as done
        q - Quit

        TXT
      )

      repo.all.last.name.should eq("test")
    end
  end
end

describe ListTasksActivity do
  after_each { TaskRepository.flush }
  
  context "can list tasks" do
    it "should list tasks when entering l" do
      ApplicationTime.set ->{ Time.utc(2010, 1, 3) }
      repo = TaskRepository.new
      task = Task.new(1, "test", Time.utc(2010, 1, 1), false)
      repo.insert(task)
      task = repo.all.last
      output_catcher = IO::Memory.new
      controller = Controller.new(output_catcher)
      controller.register("main") { |ctrl| MainActivity.new(ctrl) }
      controller.register("list_tasks") { |ctrl| ListTasksActivity.new(ctrl) }
      controller.push("main")

      fake_input = IO::Memory.new("l\nq\nq")
      controller.run(fake_input)

      output_catcher.to_s.should eq(
        <<-TXT
        Menu -
        l - List Tasks
        a - Add Task
        r - Remove Task
        d - Mark task as done
        q - Quit
        ##{task.id} - [2d] test
        
        Press [ENTER] to continue
        
        Menu -
        l - List Tasks
        a - Add Task
        r - Remove Task
        d - Mark task as done
        q - Quit\n
        TXT
      )
    end
  end
end
