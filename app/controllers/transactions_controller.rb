class TransactionsController < Sinatra::Base
  get '/transacoes' do
    { key: 'transacoes' }.to_json
  end
end
