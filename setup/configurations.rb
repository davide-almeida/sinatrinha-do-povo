require 'sinatra'
require 'rack/cors'
require 'json'

before do
  content_type :json
end

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: [:get, :post, :options]
  end
end
