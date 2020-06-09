class GroceriesController < ApplicationController

    get "/users/:id/lists/:list_id" do
        if logged_in? && (params[:id] == session[:user_id])
            @user = set_by_id
            @list = ShoppingList.find_by(id: params[:list_id])
            erb :"groceries/index"
        else
            redirect to "sessions/login"
        end
    end

    get "/users/:id/lists/:list_id/groceries/:item_id/edit" do
        if logged_in? && (params[:id] == session[:user_id])
            @user = set_by_id
            @list = ShoppingList.find_by(id: params[:list_id])
            @item = Grocery.find_by(id: params[:item_id])
            erb :"groceries/edit"
        else
            redirect to "sessions/login"
        end
    end

    post "/users/:id/lists/:list_id" do
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
            redirect to "users/#{session[:user_id]}/lists/#{@list.id}"
        end
    end

    put "/users/:id/lists/:list_id/groceries/:item_id/edit" do
        @user = set_by_id
        @list = ShoppingList.find_by(id: params[:list_id])
        @item = Grocery.find_by(id: params[:item_id])
        if params[:edit_item_name] == "" || params[:edit_item_quantity] == ""
            @error = "Please enter a name and quantity for the item."
            erb :"groceries/edit"
        else
            # binding.pry
            @item.update(name: params[:edit_item_name], quantity: params[:edit_item_quantity], shopping_list_id: params[:associated_list])
            redirect to "users/#{session[:user_id]}/lists/#{@list.id}"
        end
    end

    delete "/users/:id/lists/:list_id/groceries/:item_id" do
        list = ShoppingList.find_by(id: params[:list_id])
        item = Grocery.find_by(id: params[:item_id])
        item.destroy
        redirect to "users/#{session[:user_id]}/lists/#{list.id}"
    end

end