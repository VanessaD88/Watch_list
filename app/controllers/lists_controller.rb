class ListsController < ApplicationController
  before_action :set_list, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def index
    if user_signed_in?
      @lists = List.where("is_public = ? OR user_id = ?", true, current_user.id)
    else
      @lists = List.where(is_public: true)
    end
  end

  def show
    # Add any necessary code for the show action here
  end

  def new
    @list = List.new
  end

  def create
    @list = List.new(list_params)
    @list.user = current_user
    if @list.save
      redirect_to list_path(@list), notice: "List created successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # displays the form for editing a list
  end

  def update
    if @list.update(list_params)
      redirect_to list_path(@list), notice: "List updated successfully!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @list.destroy
    redirect_to lists_path, notice: "List deleted successfully!"
  end

  private

  def set_list
    @list = List.find(params[:id])
  end

  def list_params
    params.require(:list).permit(:name, :photo)
  end

  def authorize_user!
    unless @list.user == current_user
      redirect_to lists_path, alert: "You can only edit your own lists!"
    end
  end
end
