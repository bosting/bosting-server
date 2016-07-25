class CreateApacheVariations < ActiveRecord::Migration[5.0]
  def change
    create_table :apache_variations do |t|
      t.string :name
      t.string :ip
      t.integer :apache_version_id
      t.integer :php_version_id
      t.integer :hosting_server_id
      t.timestamps
    end
    add_index :apache_variations, :hosting_server_id
  end
end
