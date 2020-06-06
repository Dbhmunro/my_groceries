class SessionsController < ApplicationController

    get "/sessions/login" do
        if logged_in?
            redirect to "lists/#{session[:user_id]}/index"
        else
            # binding.pry

            erb :"sessions/login"
        end
    end

    post "/sessions" do
        user = User.find_by(email: params[:email].downcase)
        if user && user.authenticate(params[:password])
            session[:user_id] = user.id.to_s
            # binding.pry
            redirect to "lists/#{session[:user_id]}/index"
        else
            @error = "Incorrect email or password."
            erb :"sessions/login"
        end
    end

    get "/sessions/logout" do
        session.clear
        redirect to "sessions/login"
    end

end