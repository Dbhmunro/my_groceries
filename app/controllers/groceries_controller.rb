class GroceriesController < ApplicationController

    get "/lists/:id/:list_id" do
        if logged_in? && (params[:id] == session[:user_id])
            @user = set_by_id
            @list = ShoppingList.find_by(id: params[:list_id])
            erb :"groceries/index"
        else
            redirect to "sessions/login"
        end
    end

    post "/lists/:id/:list_id" do
        @user = set_by_id
        @list = ShoppingList.find_by(id: params[:list_id])
        if params[:new_item_name] == "" || params[:new_item_quantity] == ""
            @error = "Please enter a name and quantity for New Item."
            erb :"groceries/index"
        else
            # binding.pry
            item = Grocery.new(name: params[:new_item_name], quantity: params[:new_item_quantity])
            @list.groceries << item
            @list.save
            redirect to "lists/#{session[:user_id]}/#{@list.id}"
        end
    end

end