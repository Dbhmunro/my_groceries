class SessionsController < ApplicationController

    get "/sessions/login" do
        erb :"sessions/login"
    end

    post "/sessions/login" do
        @user = User.new(username: params[:username].downcase, email: params[:email].downcase, password: params[:password])
        @user.save
        session[:user_id] = @user.id
        redirect to "/"
    end

    get "/sessions/logout" do
    end

end
