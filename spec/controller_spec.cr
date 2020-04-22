require "./spec_helper"

describe Controller do
  describe "#open?" do
    it "is open by default" do
      controller = Controller.new
      controller.open?.should be_truthy
    end

    it "is close when no activity run after update" do
      controller = Controller.new
      controller.run()
      controller.open?.should be_falsey
    end
  end
end
