class CreateKeywords < ActiveRecord::Migration
  def self.up
    create_table :keywords do |t|
      t.string :keyphrase
      t.text :description
      t.integer :user_id

      t.timestamps
    end
    add_index :keywords, :user_id
  end

  def self.down
    drop_table :keywords
  end
end
