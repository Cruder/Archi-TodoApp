require "./repository"
require "./task"

class TaskRepository < Repository
    def self.flush
        Model::Task.clear
    end

    def all
        default_scope.select.map { |model| to_task(model) }
    end

    def active
        default_scope.where(done: false).select.map { |model| to_task(model) }
    end

    def insert(task : Task)
        Model::Task.create(name: task.name, creation_date: task.creation_date, done: task.done?)
    end

    def remove(id)
        Model::Task.find(id).try(&.destroy)
    end

    def complete(id)
        Model::Task.find(id).try(&.update(done: true))
    end

    def find(id)
        Model::Task.find(id)
    end

    private def default_scope
        Model::Task.order(creation_date: :asc)
    end

    private def to_task(model : Model::Task) : Task
        Task.new(id: model.id, name: model.name, creation_date: model.creation_date, done: model.done)
    end
end