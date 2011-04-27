# == Schema Information
# Schema version: 20101107002904
#
# Table name: users
#
#  id                :integer         primary key
#  name              :string(255)     not null
#  email             :string(255)     not null
#  crypted_password  :string(255)     not null
#  password_salt     :string(255)     not null
#  persistence_token :string(255)     not null
#  perishable_token  :string(255)     not null
#  created_at        :timestamp
#  updated_at        :timestamp
#  admin             :boolean
#  level             :integer         default(0)
#  last_tutorial     :integer         default(0)
#  buyer             :boolean
#


class User < ActiveRecord::Base
	attr_accessible :id, :name, :email, :password, :password_confirmation, :openid_identifier, :last_tutorial, :network_ids, :photo

  acts_as_authentic do |c|
    if RAILS_ENV == 'test' # avoid collisions on "name already taken" stuff
      c.validate_email_field = false
    end
  end
  validates_presence_of :name

 	has_attached_file :photo, :styles => { :medium => "175x250>", :small => "100x125>", :thumb => "50x60>" },
                  :url  => "/images/users/:id/:style/:basename.:extension",
                  :path => ":rails_root/public/images/users/:id/:style/:basename.:extension"

	#validates_attachment_presence :photo
	#validates_attachment_size :photo, :less_than => 5.megabytes
	#validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png', 'image/gif']

  has_many :websites, :dependent => :destroy
  has_many :keywords, :dependent => :destroy
  has_many :contents, :through => :keywords
  has_many :projects, :dependent => :destroy

	has_many :memberships
	has_many :networks, :through => :memberships

	has_many :relationships, :foreign_key => "user_id", :dependent => :destroy
	has_many :friends, :through => :relationships, :source => :followed

	has_many :reverse_relationships, :foreign_key => "friend_id", :class_name => "Relationship", :dependent => :destroy
	has_many :followers, :through => :reverse_relationships, :source => :follower

	has_many :sent_messages, :foreign_key => "user_id", :class_name => "MessageSystem"
	has_many :inbox_messages, :foreign_key => "receiver_id", :class_name => "MessageSystem"

	has_many :microposts
	
	def add_networks( network )
		memberships.create!(:network_id => network )
	end

	def remove_networks( network )
		memberships.find_by_network_id( network ).destroy
	end

	def add_friend!(friend)
		relationships.create!(:friend_id => friend)
	end

	def remove_friend!(friend)
		relationships.find_by_friend_id(friend).destroy
	end

	def send_message!(receiver, subject, body)
		sent_messages.create!(:receiver_id => receiver, :message_id => receiver, :subject => subject, :body => body )
	end

	def deliver_password_reset_instructions!
		reset_perishable_token!
		Notifier.deliver_password_reset_instructions(self)
	end

	def deliver_activation_instructions!
		reset_perishable_token!
		Notifier.deliver_activation_instructions(self)
	end

	def deliver_welcome!
		Notifier.deliver_welcome(self)
	end

	def activate!
		self.active = true
		save
	end
end
