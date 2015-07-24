class CreateDefendPeriods < ActiveRecord::Migration
  def change
    create_table :defend_periods do |t|
      t.timestamp :start
      t.timestamp :finish
      t.references :round, index: true
      t.timestamps null: false
    end
  end
end
