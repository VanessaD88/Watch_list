class CreateLists < ActiveRecord::Migration[7.1]
  def change
    create_table :lists do |t|
      t.string :name
      t.references :user, null: false, foreign_key: true
      t.text :description
      t.boolean :is_public

      t.timestamps
    end
  end
end
