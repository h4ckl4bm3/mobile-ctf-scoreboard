class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :title
      t.string :message
      t.timestamps null: false
      t.references :user, index: true
    end
  end
end
