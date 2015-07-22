class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.timestamp :start
      t.timestamp :finish
      t.timestamps null: false
    end
  end
end
