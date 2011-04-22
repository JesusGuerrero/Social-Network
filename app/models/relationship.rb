class Relationship < ActiveRecord::Base
	attr_accessible :friend_id, :user_id

	belongs_to :follower, :foreign_key => "user_id", :class_name => "User"
	belongs_to :followed, :foreign_key => "friend_id", :class_name => "User"

	validates_presence_of :user_id, :friend_id


end
