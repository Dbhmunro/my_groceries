class UsersController < ApplicationController
    before "*" do
        pass if request.path_info == "/new"
        current_user
    end

    set(:auth) do |user|
        condition do
            unless logged_in?
                redirect "sessions/login", 303
            end
        end
    end

    #new
    get "/new" do
        if logged_in?
            redirect to "lists/index"
        end
        erb :"users/new"
    end
    
    #show
    get "/", :auth => :user do
        erb :"users/show"
    end
    
    #edit
    get "/edit", :auth => :user do
        erb :"users/edit"
    end
    
    get "/edit_password", :auth => :user do
        erb :"users/edit_password"
    end
    
    #create
    post "/new" do
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
    put "/edit" do
        if params.has_value?("")
            @error = "Please fill in all fields."
            erb :"users/edit"
        else
            if (User.find_by(email: params[:email].downcase).email != @user.email) && (User.find_by(email: params[:email].downcase))
                @error = "Email address already in use."
                erb :"users/edit"
            else
                if @user.authenticate(params[:password])
                    @user.update(username: params[:username], email: params[:email].downcase)
                    redirect to "/"
                else
                    @error = "Incorrect password"
                    erb :"users/edit"
                end
            end
        end
    end
    
    patch "/edit_password" do
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
    delete "/" do
        @user.destroy
        session.clear
        redirect to "sessions/login"
    end
    
end