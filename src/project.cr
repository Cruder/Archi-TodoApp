require "granite"
require "granite/adapter/sqlite"

Granite::Connections << Granite::Adapter::Sqlite.new(name: "sqlite", url: "sqlite3://db/db.sql")

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

class ApplicationTime
  @@catch = -> { Time.utc }

  def self.set(new_catch : Proc(Time))
    @@catch = new_catch
  end

  def self.get : Time
    @@catch.try(&.call) || Time.utc
  end
end


abstract class Repository
  abstract def all
end

class TaskRepository < Repository
  @@tasks = [] of Task
  @@id = 0

  def self.flush
    @@tasks = [] of Task
    @@id = 0
  end

  def all
    return @@tasks if @@tasks.size < 2
    @@tasks.sort { |a, b| a.creation_date <=> b.creation_date }
  end

  def active
    all.reject { |task| task.done? }
  end

  def insert(task)
    @@id += 1
    task.id = @@id
    @@tasks << task
  end

  def remove(id)
    @@tasks.reject! { |task| task.id == id }
  end
end

class Task
  setter id : Int32?
  getter id : Int32?

  private getter name : String
  getter creation_date : Time

  def initialize(@name, @creation_date = ApplicationTime.get, @done = false)
  end

  def complete
    @done = true
  end

  def done? : Bool
    @done
  end

  def to_s(io)
    io << "[#{display_span(existance_time)}] #{name}"
  end

  def existance_time : Time::Span
    ApplicationTime.get - creation_date
  end

  def display_span(span : Time::Span) : String
    if span.days > 30
      "#{span.days // 30} month"
    elsif span.days > 0
      "#{span.days}d"
    elsif span.hours > 0
      "#{span.hours}h"
    elsif span.minutes > 0
      "#{span.minutes}min"
    else
      "#{span.seconds}s"
    end
  end
end
