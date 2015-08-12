class AddFlagIndexesAndAttackPeriodPoints < ActiveRecord::Migration
  def change
    add_index :flags, :flag
    add_index :flag_submissions, :flag
    add_column :attack_periods, :flag_point_value, :integer
    add_column :attack_periods, :submission_point_multiplier, :decimal
    add_column :rounds, :integrity_point_value, :integer
  end
end
