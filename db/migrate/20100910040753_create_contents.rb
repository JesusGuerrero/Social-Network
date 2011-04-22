class CreateContents < ActiveRecord::Migration
  def self.up
    create_table :contents do |t|
      t.string :link_url
      t.integer :keyword_id

      t.timestamps
    end
    add_index :contents, :keyword_id
  end

  def self.down
    drop_table :contents
  end
end
