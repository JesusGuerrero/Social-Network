class CreateUsedKeywords < ActiveRecord::Migration
  def self.up
    create_table :used_keywords do |t|
      t.integer :keyword_id
      t.integer :project_id
      
      t.timestamps
    end
  end

  def self.down
    drop_table :used_keywords
  end
end
