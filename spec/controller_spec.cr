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
  context "can quit" do
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
        r - Remove Task
        q - Quit
        TXT
      )
    end
  end
end
