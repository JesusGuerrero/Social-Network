class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.string :photo_file_name
      t.string :photo_content_type
      t.integer :photo_file_size
      t.datetime :photo_updated_at
      t.integer :user_id
      t.integer :network_id

      t.timestamps
    end
		add_index :photos, :user_id
		add_index :photos, :network_id
  end

  def self.down
    drop_table :photos
  end
end
