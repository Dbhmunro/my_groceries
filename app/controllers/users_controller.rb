class UsersController < ApplicationController

    get "/users/new" do
        if logged_in? && (params[:id] == session[:user_id])
            redirect to "lists/#{session[:user_id]}/index"
        else
            erb :"users/new"
        end 
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
        @user = set_by_id
        if logged_in? && (params[:id] == session[:user_id])
            erb :"users/edit"
        else
            redirect to "lists/#{session[:user_id]}/index"
        end
    end
    
    get "/users/:id/edit_password" do
        @user = set_by_id
        if logged_in? && (params[:id] == session[:user_id])
            erb :"users/edit_password"
        else
            redirect to "users/#{session[:user_id]}"
        end
    end
    
    get "/users/:id/delete" do
        #user.destroy or user.delete?
        user = set_by_id
        if logged_in? && (params[:id] == session[:user_id])
            user.destroy #need to ensure deletion of all related db items
            session.clear
            redirect to "sessions/login"
        else
            redirect to "users/#{session[:user_id]}"
        end
    end
    
    post "/users/new" do
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
                    user = User.new(username: params[:username], email: params[:email].downcase, password: params[:password])
                    user.save
                    redirect to "sessions/login"
                end
            end
        end
    
    put "/users/:id/edit" do
        @user = set_by_id
        if params.has_value?("")
            @error = "Please fill in all fields."
            erb :"users/edit"
        else
            # binding.pry
            if (User.find_by(email: params[:email].downcase).email != @user.email) && (User.find_by(email: params[:email].downcase))
                @error = "Email address already in use."
                erb :"users/edit"
            else
                if @user.authenticate(params[:password])
                    @user.update(username: params[:username], email: params[:email].downcase)
                    redirect to "users/#{session[:user_id]}"
                else
                    @error = "Incorrect password"
                    erb :"users/edit"
                end
            end
        end
    end

    patch "/users/:id/edit_password" do
        @user = set_by_id
        if params.has_value?("")
            @message = "Please fill in all fields."
            erb :"users/edit_password"
        elsif @user.authenticate(params[:password]) && (params[:password_new_1] == params[:password_new_2])
            @user.password = params[:password_new_1]
            @user.save
            @message = "Password updated."
            erb :"users/edit_password"
        elsif !(@user.authenticate(params[:password]))
            @message = "Incorrect password."
            erb :"users/edit_password"
        elsif params[:password_new_1] != params[:password_new_2]
            @message = "New password does not match with confirmation."
            erb :"users/edit_password"
        end
    end

end