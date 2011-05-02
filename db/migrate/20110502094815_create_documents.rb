class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
      t.string :document_file_name
      t.string :document_content_type
      t.integer :document_file_size
      t.datetime :document_updated_at
      t.integer :user_id
      t.integer :network_id

      t.timestamps
    end
		add_index :documents, :user_id
		add_index :documents, :network_id
  end

  def self.down
    drop_table :documents
  end
end
