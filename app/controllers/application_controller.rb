require './config/environment'

class ApplicationController < Sinatra::Base
  
  
  configure do
    # enable :sessions
    # set :session_secret, "secret"
    use Rack::Session::Cookie,  :key => 'rack.session',
                                :path => '/',
                                :secret => 'your_secret'
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get "/" do
    # erb :welcome
    if logged_in?
      redirect to "index/#{session[user_id]}/index"
    else
      redirect to "sessions/login"
    end
  end

  helpers do

    def set_by_id
      User.find_by(id: params[:id])
    end

    def logged_in?
      !!session[:user_id]
    end

  end

end
