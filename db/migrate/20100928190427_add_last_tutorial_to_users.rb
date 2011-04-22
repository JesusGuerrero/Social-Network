class AddLastTutorialToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :last_tutorial, :integer, :default => 0
  end

  def self.down
    remove_column :users, :last_tutorial
  end
end
