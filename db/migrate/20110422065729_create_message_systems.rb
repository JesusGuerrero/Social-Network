class CreateMessageSystems < ActiveRecord::Migration
  def self.up
    create_table :message_systems do |t|
      t.integer :user_id
      t.integer :receiver_id
      t.integer :message_id
			t.string	:subject
			t.text		:body

      t.timestamps
    end
	add_index :message_systems, :user_id
	add_index :message_systems, :receiver_id
	add_index :message_systems, :message_id
  end

  def self.down
    drop_table :message_systems
  end
end
