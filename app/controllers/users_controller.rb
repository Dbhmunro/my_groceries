class UsersController < ApplicationController

    get "/users/new" do
        erb :"users/new"
    end

    get "/users/delete" do
        #user.destroy or user.delete
    end

    get "/users/:id" do
        erb :"users/show"
    end

    get "/users/:id/edit" do
        erb :"users/edit"
    end

    
end