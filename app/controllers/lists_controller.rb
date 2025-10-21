class ListsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_list, only: [:show]

   def index
    @lists=List.all
    end

  def show
  end

  private
  def set_list
    @list = List.find(params[:id])
  end

end
