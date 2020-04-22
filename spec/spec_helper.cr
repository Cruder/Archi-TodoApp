require "spec"
require "dotenv"

Dotenv.load "config/.env.test"

require "../src/task_repository"
require "../src/application_time"
require "../src/task_span_formatter"
require "../src/controller"
require "../src/activities/*"
