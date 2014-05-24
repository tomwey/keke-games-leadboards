class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :name
      t.string :udid

      t.timestamps
    end
    add_index :users, :udid, :unique => true
  end
end
