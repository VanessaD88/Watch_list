class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home #check
  end


  def my_lists
    # get all the lists associaed to this user (current_user.lists)
    # for each list, get the movies,
    # display the movies

    # the route for this should be something like
    # get "/my_lists", to: "pages#my_lists"
  end

end
