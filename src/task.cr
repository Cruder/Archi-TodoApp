require "granite"
require "granite/adapter/sqlite"
require "./application_time.cr"

Granite::Connections << Granite::Adapter::Sqlite.new(name: "sqlite", url: "sqlite3://db/db.sql")

class Task
    setter id : Int64?
    getter id : Int64?
  
    getter name : String
    getter creation_date : Time
  
    def initialize(@id : Int64 | Nil, @name, @creation_date = ApplicationTime.get, @done = false)
    end
  
    def initialize(@name, @creation_date = ApplicationTime.get, @done = false)
    end
  
    def done? : Bool
      @done
    end
  
    def ==(other)
      self.id != nil && self.id == other.id
    end
  
    def to_string(task_span_formatter : TaskSpanFormatter)
      "##{id} - [#{task_span_formatter.format(existance_time)}] #{name}"
    end
  
    def existance_time : Time::Span
      ApplicationTime.get - creation_date
    end
end

module Model
    class Task < Granite::Base
      connection sqlite
  
      table tasks
  
      column id : Int64, primary: true
  
      column name : String
      column creation_date : Time
      column done : Bool
    end
end