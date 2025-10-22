class MessagesController < ApplicationController
  before_action :set_user
  before_action :set_chat

  def new
    @message = Message.new
  end

 def create
    # Find chat via set_chat
    # Save the user's message
    # create! as an allternative to new that immediately saves the record
    @message = @chat.messages.create!(
      content: params[:content],
      role: "user"
    )

    # Prepare AI chat
    chat_client = RubyLLM.chat

    # Build AI prompt
    prompt = <<~PROMPT
      You are a helpful movie recommendation assistant.
      Recommend movies based on genres, actors, mood, or themes.
      Reply naturally and include 2–3 movie suggestions if possible.
    PROMPT

    # Ask AI for a reply
    ai_response = chat_client.with_instructions(prompt).ask(@message.content)

    # Save AI response as a new message
    @chat.messages.create!(
      content: ai_response.content,
      role: "assistant"
    )

    # Redirect to the chat page
    redirect_to user_chat_path(@user, @chat)
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_chat
    @chat = @user.chats.find(params[:chat_id])
  end
end
