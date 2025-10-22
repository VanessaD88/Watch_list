class BookmarksController < ApplicationController
  before_action :set_list, only: [:new, :create]
  before_action :authorize_list_owner!

  def new
    @bookmark = Bookmark.new
  end

  def create
    @bookmark = Bookmark.new(bookmark_params)
    @bookmark.list = @list
    if @bookmark.save
        redirect_to list_path(@list), notice: 'Movie was successfully added.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @bookmark = Bookmark.find(params[:id])
    @bookmark.destroy
    redirect_to list_path(@bookmark.list), notice: "Movie removed from list."
  end

  private

  def bookmark_params
    params.require(:bookmark).permit(:movie_id, :comment)
  end

  def set_list
    @list = List.find(params[:list_id])
  end

  def authorize_list_owner!
  return if current_user == @list.user

  redirect_to list_path(@list), alert: "You cannot modify, you are not the user."
end
end
