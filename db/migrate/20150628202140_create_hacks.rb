class CreateHacks < ActiveRecord::Migration
  def change
    create_table :hacks do |t|
      t.boolean  :success
      t.string :script
      t.timestamps :time_ran
      t.timestamps null: false
    end
  end
end
