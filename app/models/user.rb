class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :lists, dependent: :destroy
  has_one :chat, dependent: :destroy

  after_create :generate_chat

  def generate_chat
    Chat.create(user: self, title: "AI chat")
  end
end
