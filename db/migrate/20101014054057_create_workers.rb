class CreateWorkers < ActiveRecord::Migration
  def self.up
    create_table :workers do |t|
      t.string :name
      t.integer :basecamp_id
      t.string :category

      t.timestamps
    end
  end

  def self.down
    drop_table :workers
  end
end
