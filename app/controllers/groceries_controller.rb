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
        @item = Grocery.new
        erb :"groceries/index"
    end

    get "/lists/:list_id/groceries/:item_id/edit" do
        if !logged_in? || !list_of_the_user? || !item_in_list?
            redirect to "sessions/login"
        end
        erb :"groceries/edit"
    end

    post "/lists/:list_id" do
        @item = Grocery.new(name: params[:new_item_name], quantity: params[:new_item_quantity])
        if @item.valid?
            @list.groceries << @item
            @list.save
            redirect to "lists/#{@list.id}"
        else
            erb :"groceries/index"
        end
    end

    put "/lists/:list_id/groceries/:item_id/edit" do
        @old_item = {:name => @item.name, :quantity => @item.quantity}
        @item.update(name: params[:edit_item_name], quantity: params[:edit_item_quantity], shopping_list_id: params[:associated_list])
        if @item.errors.any?
            erb :"groceries/edit"
        else
            redirect to "lists/#{@list.id}"
        end
    end

    delete "/lists/:list_id/groceries/:item_id" do
        @item.destroy
        redirect to "lists/#{list.id}"
    end

end