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
    # build conversation context from all previous messages
    conversation_history = @chat.messages.order(:created_at).map do |msg|
      "#{msg.role.capitalize}: #{msg.content}"
    end.join("\n")
    # (This gives the AI the full back-and-forth history)

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
    Respond with bullet points only. Each bullet must start and end with ** and contain one movie title from the catalog using the keyword "Title:" plus a concise reason for the recommendation.
    Avoid suggesting movies the user already has unless they explicitly request a rewatch.
    At the end of every message add: "Your movie has been added to the recommendation list"
      The next user message is:
      #{@message.content}
    PROMPT
    # Ask AI for a reply
    # ai_response = chat_client.with_instructions(prompt).ask(@message.content)
    ai_response = chat_client.ask(prompt)
    # Save AI response as a new message
    @chat.messages.create!(
      content: ai_response.content,
      role: "assistant"
    )

    # use the movies title to find the corrsponding instance in the db
    titles = ai_response.content.scan(/\*\*Title:\s*(.*?)\:\*\*/).flatten # responds with array of movie titles
    movies = titles.map do |title|
      Movie.where("title ILIKE ?", "%#{title}%")
    end.flatten

    # create a list/bookmark for the current user and the suggested movies
    # Find or create the Recommendations list for the current user
    recommendations_list = current_user.lists.find_or_create_by!(name: "Recommendations")
    if recommendations_list.nil?
      recommendations_list = List.create!(name: "Recommendations", user: current_user)
    end

    movies.each do |movie|
      Bookmark.find_or_create_by!(
        list: recommendations_list,
        movie: movie,
      )
    end

    redirect_to chats_path(@chat)
  end

  private

  def set_chat
    @chat = current_user.chat || current_user.create_chat
  end
end
