require './app/models/client'
require './app/models/transaction'
require 'json'

class ClientsController < Sinatra::Base
  post '/clientes/:id/transacoes' do
    body = request.body.read
    parsed_body = JSON.parse(body, symbolize_names: true)
    content_type :json

    halt 422 unless (1..10).cover? parsed_body[:descricao]&.length
    halt 422 unless parsed_body[:valor].is_a?(Integer)
    halt 422 unless ['c', 'd'].include?(parsed_body[:tipo])

    client = nil

    ConnectDatabase.pool.with do |conn|
      conn.transaction do
        client = Client.by_id(params[:id], conn)

        if client.nil?
          halt 404
        end

        sent_amount = parsed_body[:tipo] == 'd' ? -parsed_body[:valor] : parsed_body[:valor]

        if client['balance'].to_i + sent_amount < -client['limit_amount'].to_i
          halt 422
        end

        client = Client.update_balance(
          params[:id],
          sent_amount,
          parsed_body[:tipo],
          conn
        ).first

        Transaction.create(
          params[:id],
          parsed_body[:valor],
          parsed_body[:tipo],
          parsed_body[:descricao],
          conn
        )
      end
    end

    status 200

    {
      limite: client['limit_amount'],
      saldo: client['balance']
    }.to_json
  end

  get '/clientes/:id/extrato' do
    client = Client.statement(params[:id])
    if client.empty?
      halt 404
    end

    status 200

    {
      "saldo": {
        "total": client.first['balance'].to_i,
        "data_extrato": Time.now,
        "limite": client.first['limit_amount'].to_i
      },
      "ultimas_transacoes": client.map do |transaction|
        {
          "valor": transaction['amount'].to_i,
          "tipo": transaction['transaction_type'],
          "descricao": transaction['transaction_description'],
          "realizada_em": transaction['created_at']
        }
      end
    }.to_json
  end
end
