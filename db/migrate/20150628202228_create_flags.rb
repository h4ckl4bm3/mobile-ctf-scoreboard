class CreateFlags < ActiveRecord::Migration
  def change
    create_table :flags do |t|
      t.string :flag
      t.timestamps null: false
      t.references :team, index: true
      t.references :round, index: true
    end
  end
end
