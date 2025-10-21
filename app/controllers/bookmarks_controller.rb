class BookmarksController < ApplicationController
  before_action :set_list
  #before_action :authorize_list_owner!

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

  private

  def bookmark_params
    params.require(:bookmark).permit(:movie_id, :comment)
  end

  def set_list
    @list = List.find(params[:list_id])
  end
end
