class CreateFlagSubmissions < ActiveRecord::Migration
  def change
    create_table :flag_submissions do |t|
      t.string :flag
      t.timestamps null: false
    end
  end
end
