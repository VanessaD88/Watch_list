class ChatsController < ApplicationController

  def index
    # @chats = @user.chats
  end

  def show
    @chat = current_user.chat
    @message = Message.new
  end

  # def new
  #   @chat = @user.chats.new
  # end

  # def create
  #   @chat = @user.chats.create(chat_params)
  #   redirect_to user_chat_path(@user, @chat)
  # end

  private

  def chat_params
    params.require(:chat).permit(:title)
  end
end
