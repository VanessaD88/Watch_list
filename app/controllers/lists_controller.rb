class ListsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  def index
    @lists = List
      .includes(:user, :bookmarks)
      .where(is_public: true)
      .order(created_at: :desc)
    render "pages/lists"
  end

  def show
    @list = List
      .includes(:user, bookmarks: :movie)
      .where(is_public: true)
      .find(params[:id])
    @bookmarks = @list.bookmarks
    @bookmark = Bookmark.new
  end
end
