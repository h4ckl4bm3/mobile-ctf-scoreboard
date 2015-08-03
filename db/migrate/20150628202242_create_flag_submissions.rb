class CreateFlagSubmissions < ActiveRecord::Migration
  def change
    create_table :flag_submissions do |t|
      t.string :flag
      t.timestamp :submitted_at
      t.boolean :success
      t.timestamps null: false
      t.references :user, index: true
      t.integer :owner_id, index: true
      t.references :attack_period, index: true
    end
  end
end
