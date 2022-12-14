require "bundler/setup"
require "deep_cloneable_checked"

require 'yaml'
require 'sqlite3'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'active_record'

I18n.enforce_available_locales = true

def load_schema
  config = YAML.load(IO.read("#{File.dirname(__FILE__)}/database.yml"))

  ActiveRecord::Base.logger = if defined?(ActiveSupport::BufferedLogger)
                                ActiveSupport::BufferedLogger.new("#{File.dirname(__FILE__)}/debug.log")
                              else
                                ActiveSupport::Logger.new("#{File.dirname(__FILE__)}/debug.log")
                              end

  db_adapter = ENV['DB']
  db_adapter ||= 'sqlite3'

  raise 'No DB Adapter selected. Pass the DB= option to pick one, or install Sqlite or Sqlite3.' if db_adapter.nil?

  ActiveRecord::Base.establish_connection(config[db_adapter])
  load("#{File.dirname(__FILE__)}/schema.rb")
end

load_schema
# require "#{File.dirname(__FILE__)}/../init.rb"
require 'models'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
