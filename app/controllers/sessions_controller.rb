class SessionsController < ApplicationController

    get "/sessions/login" do
        if logged_in?
            redirect to "lists/index"
        end
        erb :"sessions/login"
    end

    get "/sessions/logout" do
        session.clear
        redirect to "sessions/login"
    end

    post "/sessions/login" do
        user = User.find_by(email: params[:email].downcase)
        if user && user.authenticate(params[:password])
            session[:user_id] = user.id.to_s
            # binding.pry
            redirect to "lists/index"
        else
            @error = "Incorrect email or password."
            erb :"sessions/login"
        end
    end

end
