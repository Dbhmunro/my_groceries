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
        @user = User.new
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
        @user = User.new(username: params[:username], email: params[:email].downcase, password: params[:password])
        if @user.valid?
            @user.save
            redirect to "sessions/login"
        else
            erb :"users/new"
        end
    end
    
    #update
    put "/edit" do
        @user.attributes = {:username => params[:username], :email => params[:email].downcase}
        if @user.valid? && @user.authenticate(params[:password])
            @user.save
            redirect to "/"
        else
            if !@user.authenticate(params[:password])
                @user.errors.add(:password, "is incorrect")
            end
            erb :"users/edit"
        end
    end
    
    patch "/edit_password" do
        if @user.authenticate(params[:current_password])
            @user.update(:password => params[:password], :password_confirmation => params[:password_confirmation])
            if @user.errors.any?
                erb :"users/edit_password"
            else
                @message = "Password updated."
                erb :"users/edit_password"
            end
        else
            if !@user.authenticate(params[:current_password])
                @user.errors.add(:current_password, "is incorrect")
            end
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