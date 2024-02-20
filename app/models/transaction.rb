require 'pg'
require './setup/connect_database'

class Transaction
  def self.create(client_id, amount, transaction_type, transaction_description, conn)
    # conn.exec_params('INSERT INTO transactions (client_id, amount, transaction_type, transaction_description) VALUES ($1, $2, $3, $4)', [client_id, amount, transaction_type, transaction_description])

    create_query = <<~SQL
      INSERT INTO transactions (client_id, amount, transaction_type, transaction_description)
      VALUES ($1, $2, $3, $4)
    SQL

    conn.exec_params(create_query, [client_id, amount, transaction_type, transaction_description])
  end
end
