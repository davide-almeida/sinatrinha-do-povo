require './app/models/client'
require './app/models/transaction'
require 'json'

class ClientsController < Sinatra::Base
  post '/clientes/:id/transacoes' do
    body = request.body.read
    parsed_body = JSON.parse(body)

    halt 404 if params[:id].to_i > 5
    halt 422 if parsed_body['descricao'].nil? || !(1..10).cover?(parsed_body['descricao'].length)
    halt 422 if !parsed_body['valor'].is_a?(Integer)
    halt 422 if !%w[c d].include?(parsed_body['tipo'])

    client = Client.test(params[:id], parsed_body['valor'], parsed_body['tipo'], parsed_body['descricao'])

    status 200
    content_type :json
    {
      limite: client['limit_amount'],
      saldo: client['balance']
    }.to_json
  rescue StandardError => e
    puts e.message
  end

  get '/clientes/:id/extrato' do
    client = Client.statement(params[:id])
    halt 404 if client.empty?

    status 200
    content_type :json
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
