class CreateMicroposts < ActiveRecord::Migration
  def self.up
    create_table :microposts do |t|
      t.integer :user_id
      t.integer :network_id
			t.integer :micropost_id
      t.string :content
		
      t.timestamps
    end
		add_index :microposts, :user_id
		add_index :microposts, :network_id
  end

  def self.down
    drop_table :microposts
  end
end
