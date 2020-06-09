class UsersController < ApplicationController

    #new
    get "/users/new" do
        if logged_in? && (params[:id] == session[:user_id])
            redirect to "users/#{session[:user_id]}/lists/index"
        else
            erb :"users/new"
        end 
    end
    
    #show
    get "/users/:id" do
        @user = set_by_id
        if logged_in? && (params[:id] == session[:user_id])
            erb :"users/show"
        else
            redirect to "/sessions/login"
        end
    end
    
    #edit
    get "/users/:id/edit" do
        @user = set_by_id
        if logged_in? && (params[:id] == session[:user_id])
            erb :"users/edit"
        else
            redirect to "/sessions/login"
        end
    end
    
    get "/users/:id/edit_password" do
        @user = set_by_id
        if logged_in? && (params[:id] == session[:user_id])
            erb :"users/edit_password"
        else
            redirect to "/sessions/login"
        end
    end
    
    #create
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
    
    #update
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
            @message2 = "Does not match New Password."
            erb :"users/edit_password"
        end
    end
    
    #destroy
    delete "/users/:id" do
        #user.destroy or user.delete?
        user = set_by_id
        user.destroy #need to ensure deletion of all related db items
        session.clear
        redirect to "sessions/login"
    end
    
end