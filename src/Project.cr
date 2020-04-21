require "spec"
require "uuid"
# TodoDone
# What do you need ?
# I use  post-its on the wall in front of my desk but when I'm traveling
# I don't have my todo list with me any more.
# I would like to have something that allows me to manage my tasks
# when I'm on my computer.
# Please note that I like simple things.
# What do you need ?
# I need to be able to manage my todo list everywhere I travel (with my laptop),
# this means that I need to add a new item on my list, mark it done, remove it,
# and list my todos ordored by older to newer.
# Do you need to identify precisely one note?
# No, I don't care. I just need to be able to mark done or delete an existing note
# Ok, you said "ordered by date", do you need to see the date
# No really, just mark the amount of time elapsed since creation, that's just what matters
# Ok, that's clear but could you please give us some exemples of what you call "amount of time" ?
# Yes I mean [22 min old], [3d old], [1 month old]. That's what you need?
# Yes, I see exactly what you mean. Do you think the "old" is needed in this context ? do you want it before or after your todo ?
#     Ah...yes, right. it doesn't make sense to repeat "old" each time as
#     it's the only date and it's clear in this context. Put it before the todo then.
# Ok Thanks!
# Let's recap our discussion with the customer and the whole team in a story(only first spec is provided, deal with it ;))

# My persona is Roger. Roger use to travel a lot and need to be able to manage it's taks everywhere in order to get things done

# As Roger
# I want to see the list of my current tasks ordered by date ascending
# In oder to be able to manage them
# Given It is the '20200310 23:52'
# Given I created a note @'20200309 20:30' with 'test1' and
# Given I created a note @'20200310 23:12' with 'test2'
# When I list my todos
# Then I see in that order:
#        [1d] test1
#     [40min] test2

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
