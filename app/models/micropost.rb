class Micropost < ActiveRecord::Base
	validates_length_of :content, :maximum => 255
	belongs_to :user
	belongs_to :network
end
