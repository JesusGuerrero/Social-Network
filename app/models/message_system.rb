class MessageSystem < ActiveRecord::Base
	attr_accessible :receiver_id, :message_id, :body, :subject, :user_id

	belongs_to :inbox, :foreign_key => "receiver_id", :class_name => "User"
	belongs_to :sent, :foreign_key => "user_id", :class_name => "User"
end
