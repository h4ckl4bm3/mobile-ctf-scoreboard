class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :title
      t.string :message
      t.timestamp :sent_at
      t.timestamps null: false
    end
  end
end
