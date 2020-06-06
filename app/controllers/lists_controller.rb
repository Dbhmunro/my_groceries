class ListsController < ApplicationController

    get "/lists/:id/index" do
        # session[:user_id]
        binding.pry
        if logged_in? && (params[:id] == session[:user_id])
            erb :"lists/index"
        else
            redirect to "sessions/login"
        end
    end

end