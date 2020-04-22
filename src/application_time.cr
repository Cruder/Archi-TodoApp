class ApplicationTime
    @@catch = -> { Time.utc }
  
    def self.set(new_catch : Proc(Time))
      @@catch = new_catch
    end
  
    def self.get : Time
      @@catch.try(&.call) || Time.utc
    end
end