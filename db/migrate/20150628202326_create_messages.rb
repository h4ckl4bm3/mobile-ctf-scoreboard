class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :title
      t.string :message
      t.timestamps null: false
      t.references :team, index: true
    end
  end
end
