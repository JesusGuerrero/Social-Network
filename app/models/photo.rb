class Photo < ActiveRecord::Base
	belongs_to :user
	belongs_to :network
	
	has_attached_file :photo, :styles => { :small => "100x125>"},
									:storage => :s3,
									:bucket => 'computerenchiladas',
									:s3_credentials => {
										:access_key_id => ENV['S3_KEY'],
										:secret_access_key => ENV['S3_SECRET']
									},
                  :url  => "/images/photos/:id/:style/:basename.:extension",
                  :path => "/images/photos/:id/:style/:basename.:extension"
	has_many :photo_comments
	validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']
end
