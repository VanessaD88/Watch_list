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
    user_list_movies =  user_list_movies = current_user.lists
      .flat_map { |list| list.bookmarks.map { |bookmark| bookmark.movie&.title } }
      .join(", ")

    # Build AI prompt
    prompt = <<~PROMPT
    You are a movie recommendation assistant.
    Suggest 3 films tailored to the user’s requested genres, actors, mood, or themes. Recommend only titles from the catalog below.
    Available movies: #{movie_list}
    The user already has these movies in their lists: #{user_list_movies}
    Respond with bullet points only. Each bullet must contain one movie title from the catalog plus a concise reason for the recommendation.
    Avoid suggesting movies the user already has unless they explicitly request a rewatch.
      PROMPT
    # Ask AI for a reply
    ai_response = chat_client.with_instructions(prompt).ask(@message.content)

    # Save AI response as a new message
    @chat.messages.create!(
      content: ai_response.content,
      role: "assistant"
    )

    # get the AI to respond with a list of movies titles from your db
    # use the movies title to find the corrsponding instance in the db
    # create a list/bookmark for the current user and the suggested movies

    # Redirect to the chat page
    # redirect_to chat_messages_path(current_user, @chat)
    redirect_to chat_path(:id)
  end

  private

  def set_chat
    @chat = current_user.chat
  end
end
