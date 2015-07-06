class CreateHacks < ActiveRecord::Migration
  def change
    create_table :hacks do |t|
      t.string :hack
      t.boolean :success
      t.timestamps :ran
      t.timestamps null: false
      t.references :team, index: true
      t.integer :target_id, index: true
      t.references :round, index: true
    end
  end
end
