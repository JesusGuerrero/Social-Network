class AddWriterLinkerToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :writer_id, :integer, :default => 0
    add_column :projects, :linker_id, :integer, :default => 0
  end

  def self.down
    remove_column :projects, :writer_id
    remove_column :projects, :linker_id
  end
end
