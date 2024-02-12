require 'pg'
require 'connection_pool'

class ConnectDatabase
  def self.connection
    @connection ||= ConnectionPool.new(size: 10, timeout: 200) do
      PG.connect(
        dbname: 'rinha',
        host: 'db',
        port: 5432,
        user: 'admin',
        password: '123'
      )
    end
  end
end
