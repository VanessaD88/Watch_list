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

      Use the following list of available movies when making recommendations:
      #{movie_list}

      Please respond in **bullet points**, with each recommendation on a new line.
      Include 2–3 movie suggestions and add a short reason why you recommend each.
      PROMPT
    # Ask AI for a reply
    ai_response = chat_client.with_instructions(prompt).ask(@message.content)

    # Save AI response as a new message
    @chat.messages.create!(
      content: ai_response.content,
      role: "assistant"
    )

    # use the movies title to find the corrsponding instance in the db
    titles = ai_response.content.scan(/\*\*(.*?)\*\*/).flatten # responds with array of movie titles
    movies = titles.map do |title|
      Movie.where("title ILIKE ?", "%#{title}%")
    end.flatten

    # create a list/bookmark for the current user and the suggested movies
    # Find or create the Recommendations list for the current user
    recommendations_list = List.find_by(name: "Recommendations", user: current_user)
    if recommendations_list.nil?
      recommendations_list = List.create!(name: "Recommendations", user: current_user)
    end

    movies.each do |movie|
      Bookmark.create!(
        list: recommendations_list,
        movie: movie,
      )
    end

    redirect_to chats_path
  end

  private

  def set_chat
    @chat = current_user.chat
  end
end
