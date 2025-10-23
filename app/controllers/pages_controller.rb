class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home

  def home #check
  end


  def my_lists
    @lists = current_user.lists
  end
end
