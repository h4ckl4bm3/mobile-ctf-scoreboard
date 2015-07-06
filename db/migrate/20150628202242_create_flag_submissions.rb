class CreateFlagSubmissions < ActiveRecord::Migration
  def change
    create_table :flag_submissions do |t|
      t.string :flag
      t.timestamps null: false
      t.references :team, index: true
      t.references :round, index: true
      t.integer :owner_id, index: true
    end
  end
end
