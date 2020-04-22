require "micrate"
require "sqlite3"
require "dotenv"

if ENV["TEST"]?
  Dotenv.load "config/.env.test"
else
  Dotenv.load "config/.env"
end

Micrate::DB.connection_url = ENV["DB_URL"] || "sqlite3://db/db.sql"
Micrate::Cli.run
