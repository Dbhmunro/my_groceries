class ListsController < ApplicationController

    #index
    get "/users/:id/lists/index" do
        if logged_in? && (params[:id] == session[:user_id])
            @user = set_by_id
            erb :"lists/index"
        else
            redirect to "sessions/login"
        end
    end

    get "/users/:id/lists/all_with_items" do
        if logged_in? && (params[:id] == session[:user_id])
            @user = set_by_id
            erb :"lists/all_with_items"
        else
            redirect to "sessions/login"
        end
    end

    get "/users/:id/lists/:list_id/edit" do
        if logged_in? && (params[:id] == session[:user_id])
            @user = set_by_id
            @list = ShoppingList.find_by(id: params[:list_id])
            erb :"lists/edit"
        else
            redirect to "sessions/login"
        end
    end

    post "/users/:id/lists/index" do
        @user = set_by_id
        if params[:new_list] == ""
            @error = "Please enter a name for New List."
            erb :"lists/index"
        else
            # binding.pry
            list = ShoppingList.new(name: params[:new_list])
            @user.shopping_lists << list
            @user.save
            redirect to "users/#{session[:user_id]}/lists/index"
        end
    end
    
    put "/users/:id/lists/:list_id/edit" do
        @user = set_by_id
        @list = ShoppingList.find_by(id: params[:list_id])
        if params[:edit_list] == ""
            @error = "Please enter a name."
            erb :"lists/index"
        else
            # binding.pry
            @list.update(name: params[:edit_list])
            redirect to "users/#{session[:user_id]}/lists/index"
        end
    end

    delete "/users/:id/lists/:list_id" do
        list = ShoppingList.find_by(id: params[:list_id])
        list.destroy
        redirect to "users/#{session[:user_id]}/lists/index"
    end

end