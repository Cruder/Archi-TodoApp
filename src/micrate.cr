require "micrate"
require "sqlite3"
require "dotenv"

Dotenv.load "config/.env"
Micrate::DB.connection_url = ENV["DB_URL"] 
Micrate::Cli.run
