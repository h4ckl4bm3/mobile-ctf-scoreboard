class CreateHacks < ActiveRecord::Migration
  def change
    create_table :hacks do |t|
      t.string :hack
      t.boolean :success
      t.timestamps :ran
      t.timestamps null: false
    end
  end
end
