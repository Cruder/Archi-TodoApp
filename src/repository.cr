abstract class Repository
    abstract def all
    abstract def active
    abstract def insert(task : Task)
    abstract def remove(id)
    abstract def complete(id)
    abstract def find(id)
end