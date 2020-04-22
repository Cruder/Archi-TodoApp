require "micrate"
require "sqlite3"
require "dotenv"

Micrate::DB.connection_url = ENV["DB_URL"] || "sqlite3://db/db.sql"
Micrate::Cli.run
