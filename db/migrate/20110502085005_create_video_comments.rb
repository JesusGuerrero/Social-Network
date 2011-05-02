class CreateVideoComments < ActiveRecord::Migration
  def self.up
    create_table :video_comments do |t|
      t.integer :user_id
      t.integer :video_id
      t.integer :comment_id
      t.string :content

      t.timestamps
    end
		add_index :video_comments, :user_id
		add_index :video_comments, :video_id
  end

  def self.down
    drop_table :video_comments
  end
end
