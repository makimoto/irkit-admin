require 'sinatra/base'
require 'net/http'
require 'json'

class App < Sinatra::Base
  get '/' do
    @irkit_commands = fetch_irkit_data
    haml :index
  end

  get '/execute/:cmd' do
    redirect '/'
  end

  private
  def fetch_irkit_data

    uri = URI.parse(ENV['IRKIT_DATA_URI'])
    res = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.get(uri)
    end
    JSON.parse(res.body)
  end
end
