class CreateChats < ActiveRecord::Migration[7.1]
  def change
    create_table :chats do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.references :favorite_list, null: false, foreign_key: true

      t.timestamps
    end
  end
end
