class CreateCards < ActiveRecord::Migration[5.1]
  def change
    create_table :cards do |t|
      t.string "value"
      t.string "suit"
      t.string "image"
      t.integer "game_id"
      t.integer "user_id"
      t.timestamps
    end
  end
end
