class AddNameAndBasecampIdToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :name, :string
    add_column :projects, :basecamp_id, :integer, :default => 0
  end

  def self.down
    remove_column :projects, :name
    remove_column :projects, :basecamp_id
  end
end
