class CreateAttackPeriods < ActiveRecord::Migration
  def change
    create_table :attack_periods do |t|
      t.timestamp :start
      t.timestamp :finish
      t.references :round, index: true
      t.references :flag, index: true
      t.timestamps null: false
    end
  end
end
