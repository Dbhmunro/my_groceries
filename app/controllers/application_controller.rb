require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    enable :sessions
    set :secret_session, "secret"
    set :public_folder, 'public'
    set :views, 'app/views'
  end

  get "/" do
    erb :welcome

    #route to login
    #or route to lists/index
  end

  helpers do

    def login

    end
    
    def logged_in?

    end

  end

end
