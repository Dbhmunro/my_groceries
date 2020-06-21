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

  # get "/" do
  #   # erb :welcome
  #   if logged_in?
  #     redirect to "users/#{session[:user_id]}/lists/index"
  #   else
  #     redirect to "sessions/login"
  #   end
  # end

  helpers do
    def current_user
      @user = User.find_by(id: session[:user_id])
    end

    def shopping_list
      @list = ShoppingList.find_by(id: params[:list_id])
    end

    def grocery_item
      @item = Grocery.find_by(id: params[:item_id])
    end

    def logged_in?
      !!session[:user_id]
    end

    def list_of_the_user?
      @user.shopping_lists.include?(@list)
    end

    def item_in_list?
      @list.groceries.include?(@item)
    end
    
  end

end
