class CreateGames < ActiveRecord::Migration[5.1]
  def change
    create_table :games do |t|
      t.string "ordered_players", default: [], array: true
      t.boolean "started", default: false
      t.text "game_cards", default: [], array: true
      t.string "stage"
      t.timestamps
    end
  end
end
