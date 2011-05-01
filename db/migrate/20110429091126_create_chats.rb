class CreateChats < ActiveRecord::Migration
  def self.up
    create_table :chats do |t|
      t.text :content
      t.integer :user_id
			t.integer :network_id

      t.timestamps
    end
		add_index :chats, :user_id
		add_index :chats, :network_id
  end

  def self.down
    drop_table :chats
  end
end
