class ListsController < ApplicationController

    get "/lists/:id/index" do
        if logged_in? && (params[:id] == session[:user_id])
            @user = set_by_id
            erb :"lists/index"
        else
            redirect to "sessions/login"
        end
    end



    post "/lists/:id/index" do
        @user = set_by_id
        if params[:new_list] == ""
            @error = "Please enter a name for New List."
            erb :"lists/index"
        else
            # binding.pry
            list = ShoppingList.new(name: params[:new_list])
            @user.shopping_lists << list
            @user.save
            redirect to "lists/#{session[:user_id]}/index"
        end
    end

end