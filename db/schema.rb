# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110502085005) do

  create_table "chats", :force => true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "network_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "chats", ["network_id"], :name => "index_chats_on_network_id"
  add_index "chats", ["user_id"], :name => "index_chats_on_user_id"

  create_table "contents", :force => true do |t|
    t.string   "link_url"
    t.integer  "keyword_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contents", ["keyword_id"], :name => "index_contents_on_keyword_id"

  create_table "keywords", :force => true do |t|
    t.string   "keyphrase"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "keywords", ["user_id"], :name => "index_keywords_on_user_id"

  create_table "memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "network_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["network_id"], :name => "index_memberships_on_network_id"
  add_index "memberships", ["user_id"], :name => "index_memberships_on_user_id"

  create_table "message_systems", :force => true do |t|
    t.integer  "user_id"
    t.integer  "receiver_id"
    t.integer  "message_id"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "message_systems", ["message_id"], :name => "index_message_systems_on_message_id"
  add_index "message_systems", ["receiver_id"], :name => "index_message_systems_on_receiver_id"
  add_index "message_systems", ["user_id"], :name => "index_message_systems_on_user_id"

  create_table "microposts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "network_id"
    t.integer  "micropost_id"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "microposts", ["network_id"], :name => "index_microposts_on_network_id"
  add_index "microposts", ["user_id"], :name => "index_microposts_on_user_id"

  create_table "networks", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photo_comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "photo_id"
    t.integer  "comment_id"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", :force => true do |t|
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.integer  "user_id"
    t.integer  "network_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "photos", ["network_id"], :name => "index_photos_on_network_id"
  add_index "photos", ["user_id"], :name => "index_photos_on_user_id"

  create_table "projects", :force => true do |t|
    t.boolean  "active",      :default => false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "basecamp_id", :default => 0
    t.integer  "writer_id",   :default => 0
    t.integer  "linker_id",   :default => 0
    t.text     "description"
    t.text     "notes"
  end

  add_index "projects", ["user_id"], :name => "index_projects_on_user_id"

  create_table "relationships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["friend_id"], :name => "index_relationships_on_friend_id"
  add_index "relationships", ["user_id"], :name => "index_relationships_on_user_id"

  create_table "tutorials", :force => true do |t|
    t.string   "name"
    t.string   "category"
    t.string   "permalink"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "page_order"
  end

  create_table "used_keywords", :force => true do |t|
    t.integer  "keyword_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name",                                  :null => false
    t.string   "email",                                 :null => false
    t.string   "crypted_password",                      :null => false
    t.string   "password_salt",                         :null => false
    t.string   "persistence_token",                     :null => false
    t.string   "perishable_token",                      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",              :default => false
    t.integer  "level",              :default => 0
    t.integer  "last_tutorial",      :default => 0
    t.boolean  "buyer",              :default => false
    t.boolean  "active",             :default => false, :null => false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  add_index "users", ["last_tutorial"], :name => "index_users_on_last_tutorial"

  create_table "video_comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "video_id"
    t.integer  "comment_id"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "video_comments", ["user_id"], :name => "index_video_comments_on_user_id"
  add_index "video_comments", ["video_id"], :name => "index_video_comments_on_video_id"

  create_table "videos", :force => true do |t|
    t.string   "title"
    t.string   "code"
    t.integer  "user_id"
    t.integer  "network_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "videos", ["network_id"], :name => "index_videos_on_network_id"
  add_index "videos", ["user_id"], :name => "index_videos_on_user_id"

  create_table "websites", :force => true do |t|
    t.string   "domain"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "websites", ["user_id"], :name => "index_websites_on_user_id"

  create_table "workers", :force => true do |t|
    t.string   "name"
    t.integer  "basecamp_id"
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
