class CreateAvailabilities < ActiveRecord::Migration
  def change
    create_table :availabilities do |t|
      t.boolean :success
      t.timestamps null: false
      t.references :team, index: true
      t.references :round, index: true
      t.references :hack, index: true
    end
  end
end
