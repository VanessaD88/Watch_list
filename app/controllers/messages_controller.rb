class MessagesController < ApplicationController

  def new
    @chat = Chat.find(params[:chat_id])
    @message = Message.new
  end

end
