class BankStatementsController < Sinatra::Base
  get '/extrato' do
    { key: 'extrato' }.to_json
  end
end
