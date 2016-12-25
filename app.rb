require 'sinatra/base'

class App < Sinatra::Base
  get '/' do
    'yo'
  end
end
