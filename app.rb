require 'sinatra/base'
require 'net/http'
require 'json'
require 'omniauth'
require 'omniauth/strategies/google_oauth2'
require 'denv'

Denv.load

class App < Sinatra::Base
  use Rack::Session::Cookie, secret: ENV['SECRET_KEY_BASE'], expire_after: 60 * 10
  use OmniAuth::Builder do
    provider :google_oauth2,
      ENV['GOOGLE_CLIENT_ID'],
      ENV['GOOGLE_CLIENT_SECRET'],
      scope: 'email',
      hd: ENV['GOOGLE_HD']
  end

  get '/auth/:provider/callback' do
    back_to = session.delete('back_to')
    authenticate!
    session['token'] = request.env['omniauth.auth'].dig('credentials', 'token')
    session['token_expires_at'] = request.env['omniauth.auth'].dig('credentials', 'expires_at')
    request.env['omniauth.auth'].to_json
    redirect back_to || '/'
  end

  get '/' do
    @irkit_commands = fetch_irkit_data
    haml :index
  end

  get '/execute/:cmd' do
    require_auth
    execute(params[:cmd])
    redirect '/'
  end

  get '/logout' do
    session.delete('token')
    session.delete('token_expires_at')
    redirect '/'
  end

  private
  def fetch_irkit_data
    uri = URI.parse(ENV['IRKIT_DATA_URI'])
    res = Net::HTTP.get(uri)
    JSON.parse(res)
  end

  def execute(cmd)
    message = fetch_irkit_data[params['cmd']]
    uri = URI.parse('https://api.getirkit.com/1/messages')
    Net::HTTP.post_form(
      uri,
      clientkey: ENV['IRKIT_CLIENTKEY'],
      deviceid: ENV['IRKIT_DEVICEID'],
      message: message,
    )
  end

  def require_auth
    unless has_valid_token?
      session['back_to'] = request.fullpath
      redirect '/auth/google_oauth2'
    end
  end

  def has_valid_token?
    if session['token'].nil? || session['token_expires_at'].nil?
      session.delete('token')
      session.delete('token_expires_at')
      return false
    end

    if session['token_expires_at'].to_i <= Time.now.to_i
      session.delete('token')
      session.delete('token_expires_at')
      return false
    end

    resp = Net::HTTP.get(URI.parse("https://www.googleapis.com/oauth2/v3/tokeninfo?access_token=#{session['token']}"))
    resp = JSON.parse(resp)
    resp['error_description'].nil?
  end

  def authenticate!
    email = request.env['omniauth.auth'].dig('info', 'email')
    unless allowed_emails.include?(email)
      raise "You don't have the permission."
    end
  end

  def allowed_emails
    if ENV['ALLOWED_EMAILS'].nil?
      return []
    end
    ENV['ALLOWED_EMAILS'].split(',')
  end
end
