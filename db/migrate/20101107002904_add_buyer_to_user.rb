class AddBuyerToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :buyer, :boolean, :default => false
  end

  def self.down
    remove_column :users, :buyer
  end
end
