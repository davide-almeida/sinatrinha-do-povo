require 'sinatra'
require 'json'
require_relative 'app/controllers/home_controller'
require_relative 'app/controllers/clients_controller'
class Server < Sinatra::Base
  set :bind, '0.0.0.0'
  set :port, 8080

  use HomeController
  use ClientsController

  # before do
  #   content_type :json
  # end

  run! if app_file == $0
end
