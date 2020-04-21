require "./spec_helper"

describe "Application" do
  after_each { TaskRepository.flush }

  context "Display a task" do
    it "Shows correct duration for month" do
      task = Task.new("test", Time.utc(2010, 1, 1))
      ApplicationTime.set -> { Time.utc(2010, 3, 2) }
      task.to_s.should eq("[2 month] test")
    end

    it "Shows correct duration for day" do
      task = Task.new("test", Time.utc(2010, 1, 1))
      ApplicationTime.set -> { Time.utc(2010, 1, 3) }
      task.to_s.should eq("[2d] test")
    end

    it "Shows correct duration for hours" do
      task = Task.new("test", Time.utc(2010, 1, 1, 1))
      ApplicationTime.set -> { Time.utc(2010, 1, 1, 5) }
      task.to_s.should eq("[4h] test")
    end

    it "Shows correct duration for minutes" do
      task = Task.new("test", Time.utc(2010, 1, 1, 1, 1))
      ApplicationTime.set -> { Time.utc(2010, 1, 1, 1, 6) }
      task.to_s.should eq("[5min] test")
    end

    it "Shows correct duration for minutes" do
      task = Task.new("test", Time.utc(2010, 1, 1, 1, 1, 0))
      ApplicationTime.set -> { Time.utc(2010, 1, 1, 1, 1, 25) }
      task.to_s.should eq("[25s] test")
    end
  end

  context "List Tasks" do
    it "Should have task ordered" do
      task1 = Task.new("test1", Time.utc(2011, 1, 1))
      task2 = Task.new("test2", Time.utc(2010, 1, 1))

      repo = TaskRepository.new
      repo.insert(task1)
      repo.insert(task2)

      tasks = repo.all

      tasks.should eq([task2, task1])
    end

    it "Should not list done tasks" do
      repo = TaskRepository.new
      repo.insert(Task.new("test done", done: true))

      repo.active.should eq([] of Task)
    end
  end

  context "Create a Task" do
    it "Should create a task" do
      ApplicationTime.set -> { Time.utc(2010, 3, 2) }
      task = Task.new("test")

      ApplicationTime.set -> { Time.utc(2010, 3, 3) }
      task.to_s.should eq("[1d] test")
    end
  end

  context "Remove a Task" do
    repo = TaskRepository.new
    repo.insert(Task.new("test"))

    repo.all.size.should eq(1)

    repo.remove(repo.all.first.id)

    repo.all.size.should eq(0)
  end

  context "Done a Task" do
    task = Task.new("test")

    task.done?.should be_falsey

    task.complete

    task.done?.should be_truthy
  end
end
