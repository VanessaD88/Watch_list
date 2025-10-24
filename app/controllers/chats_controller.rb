class ChatsController < ApplicationController

  def index
    @chat = current_user.chat || current_user.create_chat
    @message = Message.new
  end


  private

  def chat_params
    params.require(:chat).permit(:title)
  end
end
