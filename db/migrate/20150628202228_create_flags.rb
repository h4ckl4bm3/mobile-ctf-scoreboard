class CreateFlags < ActiveRecord::Migration
  def change
    create_table :flags do |t|
      t.string :flag
      t.timestamps null: false
      t.references :user, index: true
      t.references :attack_period, index: true
    end
  end
end
