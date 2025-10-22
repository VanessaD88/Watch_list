class ChatsController < ApplicationController
  before_action :set_user

  def index
    # @chats = @user.chats
  end

  def show
    # @chat = @user.chats.find(params[:id])
  end

  def new
    @chat = @user.chats.new
  end

  def create
    @chat = @user.chats.create(chat_params)
    redirect_to user_chat_path(@user, @chat)
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def chat_params
    params.require(:chat).permit(:title)
  end
end
