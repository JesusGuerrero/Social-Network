class Network < ActiveRecord::Base
	validates_length_of :description, :name, :maximum => 255

	has_many :memberships
	has_many :microposts

	has_many :reverse_relationships, :foreign_key => "network_id", :class_name => "Membership"
	has_many :users, :through => :reverse_relationships

	has_many :messages
	has_many :videos
	has_many :photos
	def get_members?( network )
		memberships.find_by_network_id( network )
	end
end
