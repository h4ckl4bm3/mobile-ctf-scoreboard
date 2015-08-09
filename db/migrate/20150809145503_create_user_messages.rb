class CreateUserMessages < ActiveRecord::Migration
  def change
    create_table :user_messages do |t|
      t.references :user, index: true
      t.references :message, index: true
      t.boolean :read
      t.timestamp :read_at
      t.timestamps null: false
    end
  end
end
