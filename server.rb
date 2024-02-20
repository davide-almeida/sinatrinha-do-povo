require 'sinatra/base'
require_relative 'app/controllers/clients_controller'

class Server < Sinatra::Base
  set :bind, '0.0.0.0'
  set :port, 8080

  use ClientsController

  run! if app_file == $0
end
