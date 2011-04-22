# == Schema Information
# Schema version: 20101106235748
#
# Table name: websites
#
#  id          :integer         primary key
#  domain      :string(255)
#  description :text
#  user_id     :integer
#  created_at  :timestamp
#  updated_at  :timestamp
#

class Website < ActiveRecord::Base
  attr_accessible :domain, :description
  
  belongs_to :user
  
  DomainRegex = /^((http|https):\/\/)?[a-z0-9]+([-.]{1}[a-z0-9]+).[a-z]{2,5}(:[0-9]{1,5})?(\/.)?$/ix
  
  validates_presence_of :domain, :description, :user_id
  validates_length_of :description, :maximum => 511
  #validates_format_of :domain, :with => DomainRegex
end
