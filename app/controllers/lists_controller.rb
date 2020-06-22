class ListsController < ApplicationController
    before "/lists*" do
        current_user
    end

    before "/lists/:list_id*" do
        shopping_list
    end

    set(:auth) do |user|
        condition do
            unless logged_in?
                redirect "sessions/login", 303
            end
        end
    end

    #index
    get "/lists/index", :auth => :user do
        @list = ShoppingList.new
        erb :"lists/index"
    end

    get "/lists/all_with_items", :auth => :user do
        erb :"lists/all_with_items"
    end

    get "/lists/:list_id/edit", :auth => :user do
        if !list_of_the_user?
            redirect to "sessions/login"
        end
        erb :"lists/edit"
    end

    post "/lists/index" do
        @list = ShoppingList.new(name: params[:new_list])
        if @list.valid?
            @user.shopping_lists << @list
            @user.save
            redirect to "lists/index"
        else
            erb :"lists/index"
        end
    end
    
    put "/lists/:list_id/edit" do
        @old_list_name = @list.name
        @list.update(name: params[:edit_list])
        if @list.errors.any?
            erb :"lists/edit"
        else
            redirect to "lists/index"
        end
    end

    delete "/lists/:list_id" do
        @list.destroy
        redirect to "lists/index"
    end

end