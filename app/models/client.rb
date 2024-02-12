require 'pg'
require './setup/connect_database'

class Client
  def self.by_id(id)
    conn.exec_params('SELECT * FROM clients WHERE id = $1 FOR UPDATE', [id]).to_a.first
  end

  def self.update_balance(id, amount)
    conn.exec_params('UPDATE clients SET balance = balance + $1 WHERE id = $2', [amount, id])
  end

  def self.statement(client_id)
    conn.exec_params(
      'SELECT * FROM clients LEFT JOIN transactions ON clients.id = transactions.client_id
      WHERE clients.id = $1
      ORDER BY transactions.created_at DESC LIMIT 10', [client_id]
    ).to_a
  end

  def self.test(client_id, amount, transaction_type, transaction_description)
    amount = -amount if transaction_type == 'd'
    sql = <<~SQL
      WITH create_transaction AS (
        INSERT INTO transactions (client_id, amount, transaction_type, transaction_description) VALUES ($1, $2, $3, $4)
      )

      UPDATE clients SET balance = balance + $2 WHERE id = $1
      RETURNING balance, limit_amount
    SQL
    conn.exec_params(sql, [client_id, amount, transaction_type, transaction_description])
  end

  private

  def self.conn
    ConnectDatabase.connection.checkout
  end
end
