require "micrate"
require "sqlite3"

Micrate::DB.connection_url = "sqlite3://db/db.sql"
Micrate::Cli.run
