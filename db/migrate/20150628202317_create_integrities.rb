class CreateIntegrities < ActiveRecord::Migration
  def change
    create_table :integrities do |t|
      t.boolean :success
      t.string :method # method used to determine integrity of application
      t.timestamps null: false
      t.references :user, index: true
      t.references :round, index: true
    end
  end
end
