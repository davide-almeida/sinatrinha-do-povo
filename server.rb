require 'sinatra'
require 'json'
require_relative './setup/configurations'
require_relative './app/controllers/home_controller'
require_relative './app/controllers/transactions_controller'
require_relative './app/controllers/bank_statements_controller'

class Server < Sinatra::Base
  set :bind, '0.0.0.0'
  set :port, 8080

  use HomeController
  use TransactionsController
  use BankStatementsController

  run! if app_file == $0
end
