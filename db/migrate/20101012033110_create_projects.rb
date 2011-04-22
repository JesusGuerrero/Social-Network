class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.boolean :active, :default => false
      t.integer :user_id
  
      t.timestamps
    end
    add_index :projects, :user_id
  end

  def self.down
    drop_table :projects
  end
end
