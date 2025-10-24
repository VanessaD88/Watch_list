class MessagesController < ApplicationController
  before_action :set_chat

  def new
    @message = Message.new
  end

  def create
    @message = @chat.messages.create!(
    content: params[:message][:content],
    role: "user"
  )

  chat_client = RubyLLM.chat

  movie_list = Movie.pluck(:title).join(", ")
  user_list_movies = current_user.lists
                                 .flat_map { |list| list.bookmarks.map { |b| b.movie&.title } }
                                 .compact
                                 .join(", ")

  prompt = <<~PROMPT
    You are a movie recommendation assistant.
    Suggest 3 films tailored to the user’s requested genres, actors, mood, or themes. Recommend only titles from the catalog below.
    Available movies: #{movie_list}
    The user already has these movies in their lists: #{user_list_movies}
    Respond with bullet points only. Each bullet must start and end with ** and contain one movie title from the catalog using the keyword "Title:" plus a concise reason for the recommendation.
    Avoid suggesting movies the user already has unless they explicitly request a rewatch.
    At the end of every message add: "Your movie has been added to the recommendation list"
    The next user message is: #{@message.content}
  PROMPT

  ai_reply = chat_client.ask(prompt)
  ai_content = ai_reply.content

  @chat.messages.create!(
    content: ai_content,
    role: "assistant"
  )

  titles = ai_content.scan(/\*\*Title:\s*(.*?)\*\*/).flatten.map(&:strip)
  # movies = titles.flat_map { |title| Movie.where("title ILIKE ?", "%#{title}%").to_a }
  movies = titles.filter_map do |title|
    Movie.find_by("LOWER(title) = ?", title.downcase.strip) ||
      Movie.where("title ILIKE ?", "%#{title}%").first
  end

  recommendations_list = current_user.lists.find_or_create_by!(name: "Recommendations", description: "AI-generated")

  movies.each do |movie|
    Bookmark.find_or_create_by!(list_id: recommendations_list.id, movie_id: movie.id)
  end

  redirect_to chats_path(@chat)
end


  private

  def set_chat
    @chat = current_user.chat || current_user.create_chat
  end
end
