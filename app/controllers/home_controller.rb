class HomeController < Sinatra::Base
  get '/' do
    { key: 'Home' }.to_json
  end
end
