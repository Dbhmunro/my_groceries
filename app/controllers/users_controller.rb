class UsersController < ApplicationController

    get "/users/new" do
        erb :"users/new"
    end

    post "/users" do
        #create a new user
        # binding.pry
        if params.has_value?("")
            @error = "Please fill in all fields."
            erb :"users/new"
        else
            if User.find_by(email: params[:email].downcase)
                @error = "Email address already in use."
                erb :"users/new"
            else
                user = User.new(username: params[:username].downcase, email: params[:email].downcase, password: params[:password])
                user.save
                redirect to "sessions/login"
            end
        end
    end

    get "/users/:id/delete" do
        #user.destroy or user.delete
        user = set_by_id
        user.destroy
        redirect to "sessions/login"
    end

    get "/users/:id" do
        @user = set_by_id
        if logged_in? && (params[:id] == session[:user_id])
            erb :"users/show"
        else
            redirect to "lists/#{session[:user_id]}/index"
        end
    end

    get "/users/:id/edit" do
        erb :"users/edit"
    end

    
end