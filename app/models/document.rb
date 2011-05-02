class Document < ActiveRecord::Base
	belongs_to :user
	belongs_to :network
	
	has_attached_file :document,
									:storage => :s3,
									:bucket => 'computerenchiladas',
									:s3_credentials => {
										:access_key_id => ENV['S3_KEY'],
										:secret_access_key => ENV['S3_SECRET']
									},
                  :url  => "/documents/:id/:basename.:extension",
                  :path => "/documents/:id/:basename.:extension"

	#validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']
end
