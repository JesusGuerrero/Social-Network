class CreateMessageSystems < ActiveRecord::Migration
  def self.up
    create_table :message_systems do |t|
      t.string :user_id
      t.string :receiver_id
      t.string :message_id

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
