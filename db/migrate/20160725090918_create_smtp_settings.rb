class CreateSmtpSettings < ActiveRecord::Migration[5.0]
  def change
    create_table :smtp_settings do |t|
      t.string :name, null: false
      t.string :value, null: false
      t.integer :hosting_server_id, null: false
      t.timestamps
    end
    add_index :smtp_settings, :hosting_server_id
  end
end
