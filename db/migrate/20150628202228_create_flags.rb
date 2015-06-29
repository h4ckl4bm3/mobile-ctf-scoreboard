class CreateFlags < ActiveRecord::Migration
  def change
    create_table :flags do |t|
      t.string :flag
      t.timestamps null: false
    end
  end
end
