class GroceriesController < ApplicationController
    before "/lists/:list_id*" do
        current_user
        shopping_list
    end

    before "/lists/:list_id/groceries/:item_id*" do
        grocery_item
    end

    get "/lists/:list_id" do
        if !logged_in? || !list_of_the_user?
            redirect to "sessions/login"
        end
        erb :"groceries/index"
    end

    get "/lists/:list_id/groceries/:item_id/edit" do
        if !logged_in? || !list_of_the_user? || !item_in_list?
            redirect to "sessions/login"
        end
        erb :"groceries/edit"
    end

    post "/lists/:list_id" do
        if params[:new_item_name] == "" || params[:new_item_quantity] == ""
            @error = "Please enter a name and quantity for New Item."
            erb :"groceries/index"
        else
            item = Grocery.new(name: params[:new_item_name], quantity: params[:new_item_quantity])
            @list.groceries << item
            @list.save
            redirect to "lists/#{@list.id}"
        end
    end

    put "/lists/:list_id/groceries/:item_id/edit" do
        if params[:edit_item_name] == "" || params[:edit_item_quantity] == ""
            @error = "Please enter a name and quantity for the item."
            erb :"groceries/edit"
        else
            @item.update(name: params[:edit_item_name], quantity: params[:edit_item_quantity], shopping_list_id: params[:associated_list])
            redirect to "lists/#{@list.id}"
        end
    end

    delete "/lists/:list_id/groceries/:item_id" do
        @item.destroy
        redirect to "lists/#{list.id}"
    end

end