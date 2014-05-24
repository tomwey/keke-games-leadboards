class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :name
      t.string :game_key

      t.timestamps
    end
    add_index :games, :game_key, :unique => true
  end
end
