require './app/models/client'
require './app/models/transaction'
require 'json'

class ClientsController < Sinatra::Base
  post '/clientes/:id/transacoes' do
    body = request.body.read
    parsed_body = JSON.parse(body, symbolize_names: true) # valor, tipo e descricao
    valor = parsed_body[:valor]
    content_type :json

    halt 422, { message: 'Descricao inválida' }.to_json if parsed_body[:descricao].nil?
    halt 422, { message: 'Descricao inválida' }.to_json if parsed_body[:descricao].empty?
    halt 422, { message: 'Descricao inválida' }.to_json if parsed_body[:descricao].length > 10
    halt 422, { message: 'Valor inválido' }.to_json if parsed_body[:valor].nil?
    halt 422, { message: 'Valor inválido' }.to_json if !parsed_body[:valor].is_a?(Integer)
    halt 422, { message: 'Tipo inválido' }.to_json if parsed_body[:tipo].nil?
    halt 422, { message: 'Tipo inválido' }.to_json if parsed_body[:tipo].empty?
    halt 422, { message: 'Tipo inválido' }.to_json if parsed_body[:tipo] != 'd' && parsed_body[:tipo] != 'c'

    client = nil

    ConnectDatabase.connection.checkout.transaction do
      client = Client.by_id(params[:id])
      if client.nil?
        halt 404, { message: 'Cliente não encontrado' }.to_json
      end

      if parsed_body[:tipo] == 'd'
        valor = -valor
        if (client['balance'].to_i + valor).abs > client['limit_amount'].to_i
          halt 422, { message: 'Saldo insuficiente' }.to_json
        end
      end

      Transaction.create(params[:id], parsed_body[:valor], parsed_body[:tipo], parsed_body[:descricao])

      Client.update_balance(params[:id], valor)

      client = Client.by_id(params[:id])
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
      halt 404, { message: 'Cliente não encontrado' }.to_json
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
