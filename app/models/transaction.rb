require 'pg'
require './setup/connect_database'

class Transaction
  def self.create(client_id, amount, transaction_type, transaction_description)
    conn.exec_params('INSERT INTO transactions (client_id, amount, transaction_type, transaction_description) VALUES ($1, $2, $3, $4)', [client_id, amount, transaction_type, transaction_description])
  end

  # def self.by_client_id(client_id)
  #   conn.exec_params(
  #     'SELECT * FROM transactions WHERE client_id = $1 ORDER BY created_at DESC LIMIT 10', [client_id]
  #   ).to_a
  # end

  def self.conn
    ConnectDatabase.connection.checkout
  end
end
