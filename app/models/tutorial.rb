# == Schema Information
# Schema version: 20101106235748
#
# Table name: tutorials
#
#  id         :integer         primary key
#  name       :string(255)
#  category   :string(255)
#  permalink  :string(255)
#  content    :text
#  created_at :timestamp
#  updated_at :timestamp
#  page_order :integer
#

class Tutorial < ActiveRecord::Base
  attr_accessible :name, :category, :permalink, :content, :page_order
  
  validates_presence_of :name, :category, :permalink, :content, :page_order
  validates_format_of :category, :permalink, :with => /^[a-zA-Z0-9\-\_]+$/, :message => "cannot contain spaces"
  validates_numericality_of :page_order, :only_integer => true
end
