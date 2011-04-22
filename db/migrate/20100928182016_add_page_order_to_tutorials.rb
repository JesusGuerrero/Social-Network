class AddPageOrderToTutorials < ActiveRecord::Migration
  def self.up
    add_column :tutorials, :page_order, :integer
  end

  def self.down
    remove_column :tutorials, :page_order
  end
end
