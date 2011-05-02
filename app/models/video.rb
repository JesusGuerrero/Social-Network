class Video < ActiveRecord::Base
	belongs_to :network

	has_many :video_comments
end
