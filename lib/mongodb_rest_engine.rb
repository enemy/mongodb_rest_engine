require 'mongodb_rest_engine/rails/routes'

module MongodbRestEngine
  class Engine < ::Rails::Engine
  end

  mattr_accessor :backend_uri
  @@backend_uri = "mongodb://localhost"

  mattr_accessor :db_name
  @@db_name = "db"

  mattr_accessor :pool_size
  @@pool_size = 5

  mattr_accessor :timeout
  @@timeout = 5

  def self.setup
    yield self
  end
end
