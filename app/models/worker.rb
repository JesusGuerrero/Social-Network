# == Schema Information
# Schema version: 20101014054057
#
# Table name: workers
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  basecamp_id :integer
#  category    :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Worker < ActiveRecord::Base
  attr_accessible :name, :basecamp_id, :category
  
  validates_presence_of :name, :basecamp_id, :category
  validates_uniqueness_of :name, :basecamp_id
end
