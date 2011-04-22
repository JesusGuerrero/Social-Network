# == Schema Information
# Schema version: 20101106235748
#
# Table name: contents
#
#  id         :integer         primary key
#  link_url   :string(255)
#  keyword_id :integer
#  created_at :timestamp
#  updated_at :timestamp
#

class Content < ActiveRecord::Base
  attr_accessible :link_url
  
  belongs_to :keyword
  
  validates_presence_of :link_url, :keyword_id
end
