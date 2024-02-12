require 'sinatra'
require 'rack/cors'

before do
  content_type :json
end

use Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: [:get, :post, :options]
  end
end
