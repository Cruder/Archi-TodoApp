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
  def self.flush
    Model::Task.clear
  end

  def all
    default_scope.select.map { |model| to_task(model) }
  end

  def active
    default_scope.where(done: true).select.map { |model| to_task(model) }
  end

  def insert(task : Task)
    Model::Task.create(name: task.name, creation_date: task.creation_date, done: task.done?)
  end

  def remove(id)
    Model::Task.find(id).try(&.destroy)
  end

  private def default_scope
    Model::Task.order(creation_date: :asc)
  end

  private def to_task(model : Model::Task) : Task
    Task.new(name: model.name, creation_date: model.creation_date, done: model.done)
  end
end

class Task
  setter id : Int32?
  getter id : Int32?

  getter name : String
  getter creation_date : Time

  def initialize(@name, @creation_date = ApplicationTime.get, @done = false)
  end

  def complete
    @done = true
  end

  def done? : Bool
    @done
  end

  def to_string(task_span_formatter : TaskSpanFormatter)
    "[#{task_span_formatter.format(existance_time)}] #{name}"
  end

  def existance_time : Time::Span
    ApplicationTime.get - creation_date
  end
end

class TaskSpanFormatter
	def format(span : Time::Span) : String
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