# == Schema Information
# Schema version: 20101106235748
#
# Table name: keywords
#
#  id          :integer         primary key
#  keyphrase   :string(255)
#  description :text
#  user_id     :integer
#  created_at  :timestamp
#  updated_at  :timestamp
#

class Keyword < ActiveRecord::Base
  attr_accessible :keyphrase, :description, :content_attributes
  
  belongs_to :user
  has_one :content, :dependent => :destroy
  has_many :used_keywords
  has_one :project,
    :through => :used_keywords,
    :source => :project
  
  accepts_nested_attributes_for :content, :allow_destroy => true
  
  validates_presence_of :keyphrase, :description, :user_id
  validates_length_of   :description, :maximum => 511
end
