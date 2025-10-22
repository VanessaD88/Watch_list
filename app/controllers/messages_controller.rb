class MessagesController < ApplicationController
  before_action :set_chat

  def new
    @message = Message.new
  end

 def create
    # Find chat via set_chat
    # Save the user's message
    # create! as an allternative to new that immediately saves the record
    @message = @chat.messages.create!(
      content: params[:message][:content],
      role: "user"
    )

    # Prepare AI chat
    chat_client = RubyLLM.chat

    movie_list = Movie.all.map {|movie| movie.title}.join(", ")

    # Build AI prompt
    prompt = <<~PROMPT
      You are a helpful movie recommendation assistant.
      Recommend movies based on genres, actors, mood, or themes.
      Reply naturally and include 2–3 movie suggestions from #{Movie.all.map} if possible.
    PROMPT
    # Ask AI for a reply
    ai_response = chat_client.with_instructions(prompt).ask(@message.content)

    raise
    # Save AI response as a new message
    @chat.messages.create!(
      content: ai_response.content,
      role: "assistant"
    )

    # get the AI to respond with a list of movies titles from your db
    # use the movies title to find the corrsponding instance in the db
    # create a list/bookmark for the current user and the suggested movies

    # Redirect to the chat page
    redirect_to user_chat_path(current_user, @chat)
  end

  private

  def set_chat
    @chat = current_user.chat
  end
end
