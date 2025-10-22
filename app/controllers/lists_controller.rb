class ListsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_list, only: [:show]

  def index
    if user_signed_in?
      @lists = List.where("is_public = ? OR user_id = ?", true, current_user.id)
    else
      @lists = List.where(is_public: true)
    end
  end

  def show
  end

  private

  def set_list
    @list = List.find(params[:id])
  end

end
