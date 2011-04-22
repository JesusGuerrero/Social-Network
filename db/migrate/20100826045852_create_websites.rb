class CreateWebsites < ActiveRecord::Migration
  def self.up
    create_table :websites do |t|
      t.string :domain
      t.text :description
      t.integer :user_id

      t.timestamps
    end
    add_index :websites, :user_id
  end

  def self.down
    drop_table :websites
  end
end
