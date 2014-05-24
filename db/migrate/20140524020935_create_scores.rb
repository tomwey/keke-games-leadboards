class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.integer :value
      t.integer :user_id
      t.integer :leaderboard_id

      t.timestamps
    end
    add_index :scores, :user_id
    add_index :scores, :leaderboard_id
  end
end
