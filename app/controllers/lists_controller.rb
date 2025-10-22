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

  def new
    @list = List.new
  end

  def create
    @list = List.new(list_params)
    @list.user = current_user
    @list.save
    if @list.save
    redirect_to list_path(@list), notice: "List created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_list
    @list = List.find(params[:id])
  end

  def list_params
    params.require(:list).permit(:name)
  end

end
