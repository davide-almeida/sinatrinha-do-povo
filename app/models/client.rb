require 'pg'
require './setup/connect_database'

class Client
  def self.by_id(id, conn)
    conn.exec_params('SELECT limit_amount, balance FROM clients WHERE id = $1 FOR UPDATE', [id]).to_a.first
  end

  def self.update_balance(id, amount, transaction_type, conn)
    # conn.exec_params('UPDATE clients SET balance = balance + $1 WHERE id = $2', [amount, id])

    # sent_amount = transaction_type == 'd' ? -amount : amount

    # if transaction_type == 'd'
    #   sent_amount = -amount
    # elsif transaction_type == 'c'
    #   sent_amount = amount
    # end

    update_query = <<~SQL
      UPDATE clients
      SET balance = balance + $1
      WHERE id = $2
      RETURNING limit_amount, balance
    SQL

    conn.exec_params(update_query, [amount, id])
  end

  def self.statement(client_id)
    ConnectDatabase.connection.checkout.exec_params(
      'SELECT clients.balance, clients.limit_amount, transactions.amount, transactions.transaction_type, transactions.transaction_description, transactions.created_at FROM clients LEFT JOIN transactions ON clients.id = transactions.client_id
      WHERE clients.id = $1
      ORDER BY transactions.created_at DESC LIMIT 10', [client_id]
    ).to_a
  end
end
