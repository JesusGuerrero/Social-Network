class AddIndexToLastTutorial < ActiveRecord::Migration
  def self.up
    add_index :users, :last_tutorial
  end

  def self.down
    remove_index :users, :last_tutorial
  end
end
