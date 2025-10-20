class Chat < ApplicationRecord
  belongs_to :user
  belongs_to :favorite_list
  has_many :messages
end
